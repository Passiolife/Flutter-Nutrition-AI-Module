import 'dart:convert';
import 'dart:typed_data';

import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../extension/date_time_extension.dart';
import '../models/food_record/food_record.dart';
import '../models/user_profile/user_profile_model.dart';
import '../models/water_record/water_record.dart';
import '../models/weight_record/weight_record.dart';
import '../util/file_utility.dart';
import '../util/path_util.dart';
import 'passio_connector.dart';

class PassioInternalConnector implements PassioConnector {
  final DatabaseFactory databaseFactory;
  final FileUtility fileUtility;

  PassioInternalConnector({
    required this.databaseFactory,
    required this.fileUtility,
  });

  // #docregion Tables
  static const _kTableRecord = 'record';
  static const _kTableUserProfile = 'user_profile';
  static const _kTableFavorite = 'favorite';
  static const _kTableWater = 'water';
  static const _kTableWeight = 'weight';
  static const _kTableUserFoods = 'user_foods';
  static const _kTableUserRecipes = 'user_recipes';

  // #end Tables

  // #docregion Columns: Common
  static const _kColumnId = 'id';
  static const _kColumnData = 'data';
  static const _kColumnCreatedAt = 'created_at';

  // #enddocregion Columns: Common

  Database? _database;

  bool isOpen() => _database != null;

  // #docregion Open
  Future<void> open() async {
    _database = await databaseFactory.openDatabase(
      join(await databaseFactory.getDatabasesPath(), 'nutrition_ai.db'),
      options: OpenDatabaseOptions(
        onCreate: (db, version) async {
          await db.execute(
            'CREATE TABLE $_kTableRecord($_kColumnId INTEGER PRIMARY KEY AUTOINCREMENT, $_kColumnData TEXT  NOT NULL, $_kColumnCreatedAt TEXT NOT NULL)',
          );
          await db.execute(
            'CREATE TABLE $_kTableUserProfile($_kColumnId INTEGER PRIMARY KEY AUTOINCREMENT, $_kColumnData TEXT  NOT NULL)',
          );
          await db.execute(
            'CREATE TABLE $_kTableFavorite($_kColumnId INTEGER PRIMARY KEY AUTOINCREMENT, $_kColumnData TEXT  NOT NULL, $_kColumnCreatedAt TEXT NOT NULL)',
          );
          await db.execute(
            'CREATE TABLE $_kTableWater($_kColumnId INTEGER PRIMARY KEY AUTOINCREMENT, $_kColumnData TEXT  NOT NULL, $_kColumnCreatedAt INTEGER NOT NULL)',
          );
          await db.execute(
            'CREATE TABLE $_kTableWeight($_kColumnId INTEGER PRIMARY KEY AUTOINCREMENT, $_kColumnData TEXT  NOT NULL, $_kColumnCreatedAt INTEGER NOT NULL)',
          );
          await db.execute(
            'CREATE TABLE $_kTableUserFoods($_kColumnId INTEGER PRIMARY KEY AUTOINCREMENT, $_kColumnData INTEGER NOT NULL)',
          );
          await db.execute(
            'CREATE TABLE $_kTableUserRecipes($_kColumnId INTEGER PRIMARY KEY AUTOINCREMENT, $_kColumnData TEXT  NOT NULL)',
          );
          return;
        },
        version: 1,
      ),
    );
  }

  // #enddocregion Open

  // #docregion Close
  Future close() async {
    await _database?.close();
    _database = null;
  }

  // #enddocregion Close

  ///
  /// #docregion Favorite
  ///

  // #docregion delete
  @override
  Future<void> deleteFavorite({required FoodRecord foodRecord}) async {
    final favorites = (await fetchFavorites())?.cast<FoodRecord?>();
    final id = favorites
        ?.firstWhere((element) => element?.refCode == foodRecord.refCode,
            orElse: () => null)
        ?.id;
    if (id != null) {
      await _database!.delete(
        _kTableFavorite,
        where: '$_kColumnId = ?',
        whereArgs: [id],
      );
    }
  }

  // #enddocregion deleteFavorite

  // #docregion fetchFavorites
  @override
  Future<List<FoodRecord>?> fetchFavorites() async {
    List<Map?>? data =
        await _database!.query(_kTableFavorite, orderBy: '$_kColumnId DESC');
    return data.map((e) {
      final foodRecordResponse =
          FoodRecord.fromJson(jsonDecode(e?[_kColumnData]));
      foodRecordResponse.id = e?[_kColumnId].toString() ?? '';
      return foodRecordResponse;
    }).toList();
  }

  // #enddocregion fetchFavorites

  // #docregion updateFavorite
  @override
  Future<void> updateFavorite(
      {required FoodRecord foodRecord, required bool isNew}) async {
    if (isNew) {
      DateTime createdAt = DateTime.fromMillisecondsSinceEpoch(
          foodRecord.getCreatedAt()?.millisecondsSinceEpoch ?? 0);
      final date = DateFormat(DateFormatStrings.yearMonthDay).format(createdAt);

      final values = {
        _kColumnCreatedAt: date,
        _kColumnData: jsonEncode(foodRecord)
      };
      final insertId = await _database!.insert(_kTableFavorite, values);
      if (insertId > 0) {
        foodRecord.id = insertId.toString();
      }
    } else {
      final row = {_kColumnData: jsonEncode(foodRecord)};
      await _database!.update(_kTableFavorite, row,
          where: '$_kColumnId = ?', whereArgs: [foodRecord.id]);
    }
  }

  // #enddocregion updateFavorite

  // #docregion favoriteExists
  @override
  Future<bool> favoriteExists({required FoodRecord foodRecord}) async {
    final favorites = (await fetchFavorites())?.cast<FoodRecord?>();
    return favorites?.firstWhere(
            (element) => element?.refCode == foodRecord.refCode,
            orElse: () => null) !=
        null;
  }

  // #enddocregion favoriteExists

  ///
  /// #enddocregion Favorite
  ///

  ///
  /// #docregion Record
  ///

  // #docregion deleteRecord
  @override
  Future<void> deleteRecord({required FoodRecord foodRecord}) async {
    await _database!.delete(_kTableRecord,
        where: '$_kColumnId = ?', whereArgs: [foodRecord.id]);
  }

  // #enddocregion deleteRecord

  // #docregion fetchDayRecords
  @override
  Future<List<FoodRecord>> fetchDayRecords({required DateTime dateTime}) async {
    final date = DateFormat('yyyyMMdd').format(dateTime);
    List<Map>? data = await _database!.query(
      _kTableRecord,
      where: '$_kColumnCreatedAt = ?',
      whereArgs: [date],
      orderBy: '$_kColumnId DESC',
    );
    return data.map((e) {
      final record = FoodRecord.fromJson(jsonDecode(e[_kColumnData]));
      record.id = e[_kColumnId].toString();
      return record;
    }).toList();
  }

  // #enddocregion fetchDayRecords

  // #docregion fetchRecords
  @override
  Future<List<FoodRecord>> fetchRecords(
      {required DateTime fromDate, required DateTime endDate}) async {
    final formattedFromDate = DateFormat('yyyyMMdd').format(fromDate);
    final formattedEndDate = DateFormat('yyyyMMdd').format(endDate);
    List<Map>? data = await _database!.query(
      _kTableRecord,
      where: '$_kColumnCreatedAt BETWEEN ? AND ?',
      whereArgs: [formattedFromDate, formattedEndDate],
      orderBy: '$_kColumnId DESC',
    );
    return data.map((e) {
      final foodRecordResponse =
          FoodRecord.fromJson(jsonDecode(e[_kColumnData]));
      foodRecordResponse.id = e[_kColumnId].toString();
      return foodRecordResponse;
    }).toList();
  }

  // #enddocregion fetchRecords

  // #docregion updateRecord
  @override
  Future<void> updateRecord({
    required FoodRecord foodRecord,
    required bool isNew,
  }) async {
    DateTime? createdAt = foodRecord.getCreatedAt();
    if (createdAt == null) return;

    final date = DateFormat(DateFormatStrings.yearMonthDay).format(createdAt);
    final values = {
      _kColumnCreatedAt: date,
      _kColumnData: jsonEncode(foodRecord),
    };

    if (isNew) {
      final insertId = await _database!.insert(_kTableRecord, values);
      if (insertId > 0) {
        foodRecord.id = insertId.toString();
      }
    } else {
      await _database!.update(_kTableRecord, values,
          where: '$_kColumnId = ?', whereArgs: [foodRecord.id]);
    }
  }

  // #enddocregion updateRecord

  ///
  /// #enddocregion Record
  ///

  ///
  /// #docregion UserFood
  ///

  // #docregion deleteUserFood
  @override
  Future<void> deleteUserFood({required FoodRecord foodRecord}) async {
    await _database!.delete(_kTableUserFoods,
        where: '$_kColumnId = ?', whereArgs: [foodRecord.id]);
  }

  // #enddocregion deleteUserFood

  // #docregion fetchUserFood
  @override
  Future<FoodRecord?> fetchUserFood({required String id}) async {
    List<Map>? data = await _database!.query(
      _kTableUserFoods,
      where: '$_kColumnId = ?',
      whereArgs: [id],
    );
    final record = data.firstOrNull;
    if (record != null) {
      final foodRecord = FoodRecord.fromJson(jsonDecode(record[_kColumnData]));
      foodRecord.id = record[_kColumnId].toString();
      return foodRecord;
    }
    return null;
  }

  // #enddocregion fetchUserFood

  // #docregion fetchUserFoods
  @override
  Future<List<FoodRecord>> fetchUserFoods() async {
    List<Map>? data = await _database!.query(
      _kTableUserFoods,
      orderBy: '$_kColumnId DESC',
    );
    return data.map((e) {
      final record = FoodRecord.fromJson(jsonDecode(e[_kColumnData]));
      record.id = e[_kColumnId].toString();
      return record;
    }).toList();
  }

  // #enddocregion fetchUserFoods

  // #docregion updateUserFood
  @override
  Future<String> updateUserFood(
      {required FoodRecord foodRecord, required bool isNew}) async {
    final values = {_kColumnData: jsonEncode(foodRecord)};

    if (isNew) {
      final insertId = await _database!.insert(_kTableUserFoods, values);
      if (insertId > 0) {
        foodRecord.id = insertId.toString();
      }
    } else {
      await _database!.update(
        _kTableUserFoods,
        values,
        where: '$_kColumnId = ?',
        whereArgs: [foodRecord.id],
      );
    }
    return foodRecord.id;
  }

  // #enddocregion updateUserFood

  // #docregion searchUserFoodsByName
  @override
  Future<List<FoodRecord>> searchUserFoodsByName({required String term}) async {
    final userFoods = await fetchUserFoods();
    final userRecipes = await fetchUserRecipes();

    final filteredUserFoods = userFoods
        .where((element) =>
            element.name.toLowerCase().contains(term.toLowerCase()))
        .toList();

    final filteredUserRecipes = userRecipes
        .where((element) =>
            element.name.toLowerCase().contains(term.toLowerCase()))
        .toList();

    final combinedList = [...filteredUserFoods, ...filteredUserRecipes];

    return combinedList;
  }

  // #enddocregion searchUserFoodsByName

  ///
  /// #end UserFood
  ///

  ///
  /// #docregion UserFoodImage
  ///

  // #docregion deleteUserFoodImage
  @override
  Future<void> deleteUserFoodImage({required String id}) async {
    String defaultImagesPath = PathUtil.userImagesPath;
    String customImagePath = '$defaultImagesPath$id.bin';
    await fileUtility.deleteFile(customImagePath);
  }

  // #enddocregion deleteUserFoodImage

  // #docregion fetchUserFoodImage
  @override
  Future<Uint8List?> fetchUserFoodImage({required String id}) async {
    String defaultImagesPath = PathUtil.userImagesPath;
    String customImagePath = '$defaultImagesPath$id.bin';
    return await fileUtility.readFile(customImagePath);
  }

  // #enddocregion fetchUserFoodImage

  // #docregion updateUserFoodImage
  @override
  Future<void> updateUserFoodImage({
    required String id,
    required Uint8List image,
    required bool isNew,
  }) async {
    String defaultImagesPath = PathUtil.userImagesPath;
    String customImagePath = '$defaultImagesPath$id.bin';
    if (isNew) {
      await fileUtility.writeFile(customImagePath, image);
    } else {
      await fileUtility.updateFile(customImagePath, image);
    }
    return;
  }

  // #enddocregion updateUserFoodImage

  // #docregion fetchUserFoodByBarcode
  @override
  Future<FoodRecord?> fetchUserFoodByBarcode({required String barcode}) async {
    final foodRecords = await fetchUserFoods();
    return foodRecords
        .cast<FoodRecord?>()
        .firstWhere((e) => e?.barcode == barcode, orElse: () => null);
  }

  // #enddocregion fetchUserFoodByBarcode

  ///
  /// #enddocregion UserFoodImage
  ///

  ///
  /// #docregion UserRecipe
  ///

  // #docregion deleteUserRecipe
  @override
  Future<void> deleteUserRecipe({required FoodRecord foodRecord}) async {
    await _database!.delete(_kTableUserRecipes,
        where: '$_kColumnId = ?', whereArgs: [foodRecord.id]);
  }

  // #enddocregion deleteUserRecipe

  // #docregion fetchUserRecipe
  @override
  Future<FoodRecord?> fetchUserRecipe({required String id}) async {
    List<Map>? data = await _database!.query(
      _kTableUserRecipes,
      where: '$_kColumnId = ?',
      whereArgs: [id],
    );
    final record = data.firstOrNull;
    if (record != null) {
      final foodRecord = FoodRecord.fromJson(jsonDecode(record[_kColumnData]));
      foodRecord.id = record[_kColumnId].toString();
      return foodRecord;
    }
    return null;
  }

  // #enddocregion fetchUserRecipe

  // #docregion fetchUserRecipes
  @override
  Future<List<FoodRecord>> fetchUserRecipes() async {
    List<Map>? data = await _database!.query(
      _kTableUserRecipes,
      orderBy: '$_kColumnId DESC',
    );
    return data.map((e) {
      final foodRecordResponse =
          FoodRecord.fromJson(jsonDecode(e[_kColumnData]));
      foodRecordResponse.id = e[_kColumnId].toString();
      return foodRecordResponse;
    }).toList();
  }

  // #enddocregion fetchUserRecipes

  // #docregion updateUserRecipe
  @override
  Future<String> updateUserRecipe(
      {required FoodRecord foodRecord, required bool isNew}) async {
    final values = {_kColumnData: jsonEncode(foodRecord)};

    // If [isNew] is [true] then perform the insert operation.
    if (isNew) {
      // await FileUtility().writeFile(
      //     foodRecord.customImagePath, image);

      final insertId = await _database!.insert(_kTableUserRecipes, values);
      if (insertId > 0) {
        foodRecord.id = insertId.toString();
      }
    } else {
      // await FileUtility().updateFile(
      //     foodRecord.customImagePath, image);
      await _database!.update(
        _kTableUserRecipes,
        values,
        where: '$_kColumnId = ?',
        whereArgs: [foodRecord.id],
      );
    }
    return foodRecord.id;
  }

  // #enddocregion updateUserRecipe

  ///
  /// #end UserRecipe
  ///

  ///
  /// #docregion WaterRecord
  ///

  // #docregion deleteWaterRecord
  @override
  Future<void> deleteWaterRecord({required WaterRecord record}) async {
    await _database!
        .delete(_kTableWater, where: '$_kColumnId = ?', whereArgs: [record.id]);
  }

  // #enddocregion deleteWaterRecord

  // #docregion fetchWaterRecords
  @override
  Future<List<WaterRecord>> fetchWaterRecords(
      {required DateTime fromDate, required DateTime endDate}) async {
    final fromDateMillis = fromDate.millisecondsSinceEpoch;
    final endDateMillis = endDate.millisecondsSinceEpoch;

    List<Map> data = await _database!.query(
      _kTableWater,
      where: '$_kColumnCreatedAt BETWEEN ? AND ?',
      whereArgs: [fromDateMillis, endDateMillis],
      orderBy: '$_kColumnId DESC',
    );
    return data
        .map((e) => WaterRecord.fromJson(e.cast<String, dynamic>()))
        .toList();
  }

  // #enddocregion fetchWaterRecords

  // #docregion updateWater
  @override
  Future<void> updateWater({
    required WaterRecord waterRecord,
    required bool isNew,
  }) async {
    final values = {
      _kColumnData: waterRecord.getWater(),
      _kColumnCreatedAt: waterRecord.createdAt
    };
    if (isNew) {
      await _database!.insert(_kTableWater, values);
    } else {
      await _database!.update(_kTableWater, values,
          where: '$_kColumnId = ?', whereArgs: [waterRecord.id]);
    }
  }

  // #enddocregion updateWater

  // #docregion fetchConsumedWater
  @override
  Future<double> fetchConsumedWater({required DateTime dateTime}) async {
    final fromDateMillis = dateTime
        .copyWith(hour: 0, minute: 0, second: 0, millisecond: 0)
        .toUtc()
        .millisecondsSinceEpoch;
    final endDateMillis = dateTime
        .copyWith(hour: 23, minute: 59, second: 59, millisecond: 999)
        .toUtc()
        .millisecondsSinceEpoch;

    List<Map> data = await _database!.query(
      _kTableWater,
      where: '$_kColumnCreatedAt BETWEEN ? AND ?',
      whereArgs: [fromDateMillis, endDateMillis],
      orderBy: '$_kColumnId DESC',
    );
    return data
        .map((e) => WaterRecord.fromJson(e.cast<String, dynamic>()))
        .toList()
        .fold<double>(
          0,
          (previousValue, element) => previousValue + element.getWater(),
        );
  }

  // #enddocregion fetchConsumedWater

  ///
  /// #end WaterRecord
  ///

  ///
  /// #docregion WeightRecord
  ///

  // #docregion deleteWeightRecord
  @override
  Future<void> deleteWeightRecord({required WeightRecord record}) async {
    await _database!.delete(_kTableWeight,
        where: '$_kColumnId = ?', whereArgs: [record.id]);
  }

  // #enddocregion deleteWeightRecord

  // #docregion fetchMeasuredWeight
  @override
  Future<double> fetchMeasuredWeight({required DateTime dateTime}) async {
    final startOfDay = DateTime.utc(
      dateTime.year,
      dateTime.month,
      dateTime.day,
    );
    final fromDateMillis = startOfDay.millisecondsSinceEpoch;

    final endOfDay = DateTime.utc(
      dateTime.year,
      dateTime.month,
      dateTime.day,
      23,
      59,
      59,
      999,
    );
    final endDateMillis = endOfDay.millisecondsSinceEpoch;

    List<Map> data = await _database!.query(
      _kTableWeight,
      where: '$_kColumnCreatedAt BETWEEN ? AND ?',
      whereArgs: [fromDateMillis, endDateMillis],
      orderBy: '$_kColumnCreatedAt DESC',
      limit: 1,
    );
    return data
        .map((e) => WeightRecord.fromJson(e.cast<String, dynamic>()))
        .toList()
        .fold<double>(
          0,
          (previousValue, element) => previousValue + element.getWeight(),
        );
  }

  // #enddocregion fetchMeasuredWeight

  // #docregion fetchWeightRecords
  @override
  Future<List<WeightRecord>> fetchWeightRecords(
      {required DateTime fromDate, required DateTime endDate}) async {
    final fromDateMillis = fromDate.toUtc().millisecondsSinceEpoch;
    final endDateMillis = endDate.toUtc().millisecondsSinceEpoch;

    List<Map> data = await _database!.query(
      _kTableWeight,
      where: '$_kColumnCreatedAt BETWEEN ? AND ?',
      whereArgs: [fromDateMillis, endDateMillis],
      orderBy: '$_kColumnId DESC',
    );
    return data
        .map((e) => WeightRecord.fromJson(e.cast<String, dynamic>()))
        .toList();
  }

  // #enddocregion fetchWeightRecords

  // #docregion updateWeight
  @override
  Future<void> updateWeight(
      {required WeightRecord record, required bool isNew}) async {
    final values = {
      _kColumnData: record.getWeight(),
      _kColumnCreatedAt: record.createdAt
    };
    if (isNew) {
      await _database!.insert(_kTableWeight, values);
    } else {
      await _database!.update(_kTableWeight, values,
          where: '$_kColumnId = ?', whereArgs: [record.id]);
    }
  }

  // #enddocregion updateWeight

  ///
  /// #end WeightRecord
  ///

  ///
  /// #docregion UserProfile
  ///

  // #docregion fetchUserProfile
  @override
  Future<UserProfileModel?> fetchUserProfile() async {
    Map? data =
        (await _database!.query(_kTableUserProfile, limit: 1)).firstOrNull;
    if (data?.containsKey(_kColumnData) ?? false) {
      final userProfile =
          UserProfileModel.fromJson(jsonDecode(data?[_kColumnData]));
      userProfile.id =
          (data?.containsKey('id') ?? false) ? data!['id'].toString() : null;
      return userProfile;
    }
    return null;
  }

  // #enddocregion fetchUserProfile

  // #docregion updateUserProfile
  @override
  Future<void> updateUserProfile(
      {required UserProfileModel userProfile, required bool isNew}) async {
    final values = {_kColumnData: jsonEncode(userProfile)};
    if (isNew) {
      final insertId = await _database!.insert(_kTableUserProfile, values);
      if (insertId > 0) {
        userProfile.id = insertId.toString();
      }
    } else {
      await _database!.update(_kTableUserProfile, values,
          where: '$_kColumnId = ?', whereArgs: [userProfile.id]);
    }
  }

// #enddocregion updateUserProfile

  ///
  /// #end UserProfile
  ///
}
