import 'dart:convert';

import 'package:intl/intl.dart';

import '../models/food_record/food_record.dart';
import '../models/user_profile/user_profile_model.dart';
import '../models/water_record/water_record.dart';
import '../models/weight_record/weight_record.dart';
import '../util/database_helper.dart';
import '../util/date_time_utility.dart';
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
      userProfile.id = (data?.containsKey('id') ?? false) ? data!['id'].toString() : null;
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

  @override
  Future<bool> favoriteExists({required FoodRecord foodRecord}) async {
    final favorites = (await fetchFavorites())?.cast<FoodRecord?>();
    return favorites?.firstWhere(
            (element) => element?.passioID == foodRecord.passioID,
            orElse: () => null) !=
        null;
  }

  @override
  Future<void> deleteFavorite({required FoodRecord foodRecord}) async {
    final favorites = (await fetchFavorites())?.cast<FoodRecord?>();
    final id = favorites
        ?.firstWhere((element) => element?.passioID == foodRecord.passioID,
            orElse: () => null)
        ?.id;
    if (id != null) {
      await _databaseHelper.database.delete(_databaseHelper.tblFavorite,
          where: '${_databaseHelper.colId} = ?', whereArgs: [id]);
    }
  }

  // Water Related Methods

  @override
  Future<int> updateWater(
      {required WaterRecord waterRecord, required bool isNew}) async {
    final values = {
      _databaseHelper.colData: waterRecord.getWater(),
      _databaseHelper.colCreatedAt: waterRecord.createdAt
    };
    if (isNew) {
      final insertId = await _databaseHelper.database
          .insert(_databaseHelper.tblWater, values);
      if (insertId > 0) {
        return insertId;
      }
    } else {
      await _databaseHelper.database.update(_databaseHelper.tblWater, values,
          where: '${_databaseHelper.colId} = ?', whereArgs: [waterRecord.id]);
      return waterRecord.id ?? 0;
    }
    return 0;
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
            0,
            (previousValue, element) =>
                previousValue + element.getWater());
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
  Future<int> updateWeight(
      {required WeightRecord weightRecord, required bool isNew}) async {
    final values = {
      _databaseHelper.colData: weightRecord.getWeight(),
      _databaseHelper.colCreatedAt: weightRecord.createdAt
    };
    if (isNew) {
      final insertId = await _databaseHelper.database
          .insert(_databaseHelper.tblWeight, values);
      if (insertId > 0) {
        return insertId;
      }
    } else {
      await _databaseHelper.database.update(_databaseHelper.tblWeight, values,
          where: '${_databaseHelper.colId} = ?', whereArgs: [weightRecord.id]);
      return weightRecord.id ?? 0;
    }
    return 0;
  }

}
