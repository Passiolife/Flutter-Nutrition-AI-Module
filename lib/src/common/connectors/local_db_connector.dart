import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import '../models/food_record/food_record.dart';
import '../models/user_profile/user_profile_model.dart';
import '../models/water_record/water_record.dart';
import '../models/weight_record/weight_record.dart';
import '../util/database_helper.dart';
import '../util/date_time_utility.dart';
import '../util/file_utility.dart';
import 'passio_connector.dart';

class LocalDBConnector implements PassioConnector {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  @override
  Future<void> updateRecord(
      {required FoodRecord foodRecord, required bool isNew}) async {
    DateTime? createdAt = foodRecord.getCreatedAt();
    if (createdAt == null) return;

    final date = createdAt.formatToString(format9);
    final values = {
      _databaseHelper.colCreatedAt: date,
      _databaseHelper.colData: jsonEncode(foodRecord)
    };

    // If [isNew] is [true] then perform the insert operation.
    if (isNew) {
      final insertId = await _databaseHelper.database
          .insert(_databaseHelper.tblFoodRecord, values);
      if (insertId > 0) {
        foodRecord.id = insertId.toString();
      }
    } else {
      await _databaseHelper.database.update(
        _databaseHelper.tblFoodRecord,
        values,
        where: '${_databaseHelper.colId} = ?',
        whereArgs: [foodRecord.id],
      );
    }
  }

  @override
  Future<List<FoodRecord>> fetchDayRecords({required DateTime dateTime}) async {
    final date = DateFormat('yyyyMMdd').format(dateTime);
    List<Map>? data = await _databaseHelper.database.query(
      _databaseHelper.tblFoodRecord,
      where: '${_databaseHelper.colCreatedAt} = ?',
      whereArgs: [date],
      orderBy: '${_databaseHelper.colId} DESC',
    );
    return data.map((e) {
      final foodRecordResponse =
          FoodRecord.fromJson(jsonDecode(e[_databaseHelper.colData]));
      foodRecordResponse.id = e[_databaseHelper.colId].toString();
      return foodRecordResponse;
    }).toList();
  }

  @override
  Future<void> deleteRecord({required FoodRecord foodRecord}) async {
    await _databaseHelper.database.delete(_databaseHelper.tblFoodRecord,
        where: '${_databaseHelper.colId} = ?', whereArgs: [foodRecord.id]);
  }

  // Favorites

  @override
  Future<void> updateFavorite(
      {required FoodRecord foodRecord, required bool isNew}) async {
    if (isNew) {
      DateTime createdAt = DateTime.fromMillisecondsSinceEpoch(
          foodRecord.getCreatedAt()?.millisecondsSinceEpoch ?? 0);
      final date = DateFormat(format9).format(createdAt);

      final values = {
        _databaseHelper.colCreatedAt: date,
        _databaseHelper.colData: jsonEncode(foodRecord)
      };
      final insertId = await _databaseHelper.database
          .insert(_databaseHelper.tblFavorite, values);
      if (insertId > 0) {
        foodRecord.id = insertId.toString();
      }
    } else {
      final row = {_databaseHelper.colData: jsonEncode(foodRecord)};
      await _databaseHelper.database.update(_databaseHelper.tblFavorite, row,
          where: '${_databaseHelper.colId} = ?', whereArgs: [foodRecord.id]);
    }
  }

  @override
  Future<List<FoodRecord>?> fetchFavorites() async {
    List<Map?>? data = await _databaseHelper.database.query(
        _databaseHelper.tblFavorite,
        orderBy: '${_databaseHelper.colId} DESC');
    return data.map((e) {
      final foodRecordResponse =
          FoodRecord.fromJson(jsonDecode(e?[_databaseHelper.colData]));
      foodRecordResponse.id = e?[_databaseHelper.colId].toString() ?? '';
      return foodRecordResponse;
    }).toList();
  }

  @override
  Future<bool> favoriteExists({required FoodRecord foodRecord}) async {
    final favorites = (await fetchFavorites())?.cast<FoodRecord?>();
    return favorites?.firstWhere(
            (element) => element?.refCode == foodRecord.refCode,
            orElse: () => null) !=
        null;
  }

  @override
  Future<void> deleteFavorite({required FoodRecord foodRecord}) async {
    final favorites = (await fetchFavorites())?.cast<FoodRecord?>();
    final id = favorites
        ?.firstWhere((element) => element?.refCode == foodRecord.refCode,
            orElse: () => null)
        ?.id;
    if (id != null) {
      await _databaseHelper.database.delete(_databaseHelper.tblFavorite,
          where: '${_databaseHelper.colId} = ?', whereArgs: [id]);
    }
  }

  @override
  Future<void> updateUserProfile({
    required UserProfileModel userProfile,
    required bool isNew,
  }) async {
    final values = {_databaseHelper.colData: jsonEncode(userProfile)};
    if (isNew) {
      final insertId = await _databaseHelper.database
          .insert(_databaseHelper.tblUserProfile, values);
      if (insertId > 0) {
        userProfile.id = insertId.toString();
      }
    } else {
      await _databaseHelper.database.update(
          _databaseHelper.tblUserProfile, values,
          where: '${_databaseHelper.colId} = ?', whereArgs: [userProfile.id]);
    }
  }

  @override
  Future<UserProfileModel?> fetchUserProfile() async {
    Map? data = (await _databaseHelper.database
            .query(_databaseHelper.tblUserProfile, limit: 1))
        .firstOrNull;
    if (data?.containsKey(_databaseHelper.colData) ?? false) {
      final userProfile =
          UserProfileModel.fromJson(jsonDecode(data?[_databaseHelper.colData]));
      userProfile.id =
          (data?.containsKey('id') ?? false) ? data!['id'].toString() : null;
      return userProfile;
    }
    return null;
  }

  @override
  Future<List<FoodRecord>> fetchRecords({
    required DateTime fromDate,
    required DateTime endDate,
  }) async {
    final formattedFromDate = DateFormat('yyyyMMdd').format(fromDate);
    final formattedEndDate = DateFormat('yyyyMMdd').format(endDate);
    List<Map>? data = await _databaseHelper.database.query(
      _databaseHelper.tblFoodRecord,
      where: '${_databaseHelper.colCreatedAt} BETWEEN ? AND ?',
      whereArgs: [formattedFromDate, formattedEndDate],
      orderBy: '${_databaseHelper.colId} DESC',
    );
    return data.map((e) {
      final foodRecordResponse =
          FoodRecord.fromJson(jsonDecode(e[_databaseHelper.colData]));
      foodRecordResponse.id = e[_databaseHelper.colId].toString();
      return foodRecordResponse;
    }).toList();
  }

  // Water Related Methods

  @override
  Future<void> updateWater({
    required WaterRecord waterRecord,
    required bool isNew,
  }) async {
    final values = {
      _databaseHelper.colData: waterRecord.getWater(),
      _databaseHelper.colCreatedAt: waterRecord.createdAt
    };
    if (isNew) {
      await _databaseHelper.database.insert(_databaseHelper.tblWater, values);
    } else {
      await _databaseHelper.database.update(_databaseHelper.tblWater, values,
          where: '${_databaseHelper.colId} = ?', whereArgs: [waterRecord.id]);
    }
  }

  @override
  Future<List<WaterRecord>> fetchWaterRecords(
      {required DateTime fromDate, required DateTime endDate}) async {
    final fromDateMillis = fromDate.toUtc().millisecondsSinceEpoch;
    final endDateMillis = endDate.toUtc().millisecondsSinceEpoch;

    List<Map> data = await _databaseHelper.database.query(
      _databaseHelper.tblWater,
      where: '${_databaseHelper.colCreatedAt} BETWEEN ? AND ?',
      whereArgs: [fromDateMillis, endDateMillis],
      orderBy: '${_databaseHelper.colId} DESC',
    );
    return data
        .map((e) => WaterRecord.fromJson(e.cast<String, dynamic>()))
        .toList();
  }

  @override
  Future<void> deleteWaterRecord({required WaterRecord record}) async {
    await _databaseHelper.database.delete(_databaseHelper.tblWater,
        where: '${_databaseHelper.colId} = ?', whereArgs: [record.id]);
  }

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

    List<Map> data = await _databaseHelper.database.query(
      _databaseHelper.tblWater,
      where: '${_databaseHelper.colCreatedAt} BETWEEN ? AND ?',
      whereArgs: [fromDateMillis, endDateMillis],
      orderBy: '${_databaseHelper.colId} DESC',
    );
    return data
        .map((e) => WaterRecord.fromJson(e.cast<String, dynamic>()))
        .toList()
        .fold<double>(
            0, (previousValue, element) => previousValue + element.getWater());
  }

  // Weight Related Methods

  @override
  Future<void> deleteWeightRecord({required WeightRecord record}) async {
    await _databaseHelper.database.delete(_databaseHelper.tblWeight,
        where: '${_databaseHelper.colId} = ?', whereArgs: [record.id]);
  }

  @override
  Future<double> fetchMeasuredWeight({required DateTime dateTime}) async {
    final fromDateMillis = dateTime
        .copyWith(hour: 0, minute: 0, second: 0, millisecond: 0)
        .toUtc()
        .millisecondsSinceEpoch;
    final endDateMillis = dateTime
        .copyWith(hour: 23, minute: 59, second: 59, millisecond: 999)
        .toUtc()
        .millisecondsSinceEpoch;

    List<Map> data = await _databaseHelper.database.query(
      _databaseHelper.tblWeight,
      where: '${_databaseHelper.colCreatedAt} BETWEEN ? AND ?',
      whereArgs: [fromDateMillis, endDateMillis],
      orderBy: '${_databaseHelper.colCreatedAt} DESC',
      limit: 1,
    );
    return data
        .map((e) => WeightRecord.fromJson(e.cast<String, dynamic>()))
        .toList()
        .fold<double>(
            0, (previousValue, element) => previousValue + element.getWeight());
  }

  @override
  Future<List<WeightRecord>> fetchWeightRecords(
      {required DateTime fromDate, required DateTime endDate}) async {
    final fromDateMillis = fromDate.toUtc().millisecondsSinceEpoch;
    final endDateMillis = endDate.toUtc().millisecondsSinceEpoch;

    List<Map> data = await _databaseHelper.database.query(
      _databaseHelper.tblWeight,
      where: '${_databaseHelper.colCreatedAt} BETWEEN ? AND ?',
      whereArgs: [fromDateMillis, endDateMillis],
      orderBy: '${_databaseHelper.colId} DESC',
    );
    return data
        .map((e) => WeightRecord.fromJson(e.cast<String, dynamic>()))
        .toList();
  }

  @override
  Future<void> updateWeight({
    required WeightRecord record,
    required bool isNew,
  }) async {
    final values = {
      _databaseHelper.colData: record.getWeight(),
      _databaseHelper.colCreatedAt: record.createdAt
    };
    if (isNew) {
      await _databaseHelper.database.insert(_databaseHelper.tblWeight, values);
    } else {
      await _databaseHelper.database.update(_databaseHelper.tblWeight, values,
          where: '${_databaseHelper.colId} = ?', whereArgs: [record.id]);
    }
  }

  @override
  Future<List<FoodRecord>> fetchUserFoods() async {
    final formattedFromDate = DateFormat('yyyyMMdd').format(DateTime.now());
    final formattedEndDate = DateFormat('yyyyMMdd').format(DateTime.now());
    List<Map>? data = await _databaseHelper.database.query(
      _databaseHelper.tblUserFoods,
      where: '${_databaseHelper.colCreatedAt} BETWEEN ? AND ?',
      whereArgs: [formattedFromDate, formattedEndDate],
      orderBy: '${_databaseHelper.colId} DESC',
    );
    return data.map((e) {
      final foodRecordResponse =
          FoodRecord.fromJson(jsonDecode(e[_databaseHelper.colData]));
      foodRecordResponse.id = e[_databaseHelper.colId].toString();
      return foodRecordResponse;
    }).toList();
  }

  @override
  Future<void> deleteUserFood({required FoodRecord foodRecord}) async {
    await _databaseHelper.database.delete(_databaseHelper.tblUserFoods,
        where: '${_databaseHelper.colId} = ?', whereArgs: [foodRecord.id]);
  }

  @override
  Future<void> updateUserFood(
      {required FoodRecord foodRecord, required bool isNew}) async {
    DateTime? createdAt = foodRecord.getCreatedAt();
    if (createdAt == null) return;

    final date = createdAt.formatToString(format9);
    final values = {
      _databaseHelper.colCreatedAt: date,
      _databaseHelper.colData: jsonEncode(foodRecord)
    };

    // If [isNew] is [true] then perform the insert operation.
    if (isNew) {
      final insertId = await _databaseHelper.database
          .insert(_databaseHelper.tblUserFoods, values);
      if (insertId > 0) {
        foodRecord.id = insertId.toString();
      }
    } else {
      await _databaseHelper.database.update(
        _databaseHelper.tblUserFoods,
        values,
        where: '${_databaseHelper.colId} = ?',
        whereArgs: [foodRecord.id],
      );
    }
  }

  @override
  Future<void> deleteUserFoodImage({required String id}) async {
    await _databaseHelper.database.delete(_databaseHelper.tblUserFoodImages,
        where: '${_databaseHelper.colId} = ?', whereArgs: [id]);
  }

  @override
  Future<Uint8List?> fetchUserFoodImage({required String id}) async {
    final Directory appDocumentsDir = await getApplicationDocumentsDirectory();
    final fullPath = '${appDocumentsDir.path}/$id.bin';
    return await FileUtility.readFile(fullPath);
  }

  @override
  Future<void> updateUserFoodImage({
    required String id,
    required Uint8List image,
    required bool isNew,
  }) async {
    final Directory appDocumentsDir = await getApplicationDocumentsDirectory();
    final fullPath = '${appDocumentsDir.path}/$id.bin';

    final values = {
      _databaseHelper.colId: id,
      _databaseHelper.colData: fullPath,
    };

    if (isNew) {
      await FileUtility.writeFile(fullPath, image);
      await _databaseHelper.database
          .insert(_databaseHelper.tblUserFoodImages, values);
    } else {
      await FileUtility.updateFile(fullPath, image);
      await _databaseHelper.database.update(
        _databaseHelper.tblUserFoodImages,
        values,
        where: '${_databaseHelper.colId} = ?',
        whereArgs: [id],
      );
    }

    return;
  }

  @override
  Future<FoodRecord?> fetchUserFoodByBarcode({required String barcode}) async {
    final foodRecords = await fetchUserFoods();
    return foodRecords
        .cast<FoodRecord?>()
        .firstWhere((e) => e?.barcode == barcode, orElse: () => null);
  }
}
