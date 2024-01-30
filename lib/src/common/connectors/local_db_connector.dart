import 'dart:convert';

import 'package:intl/intl.dart';

import '../models/food_record/food_record.dart';
import '../models/user_profile/user_profile_model.dart';
import '../util/database_helper.dart';
import 'passio_connector.dart';

class LocalDBConnector implements PassioConnector {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  @override
  Future<void> updateRecord(
      {required FoodRecord foodRecord, required bool isNew}) async {
    // If [isNew] is [true] then perform the insert operation.
    if (isNew) {
      DateTime createdAt = DateTime.fromMillisecondsSinceEpoch(
          foodRecord.createdAt?.toInt() ?? 0);
      final date = DateFormat('yyyyMMdd').format(createdAt);

      final values = {
        _databaseHelper.colCreatedAt: date,
        _databaseHelper.colData: jsonEncode(foodRecord)
      };
      final insertId = await _databaseHelper.database
          .insert(_databaseHelper.tblFoodRecord, values);
      if (insertId > 0) {
        foodRecord.id = insertId.toString();
      }
    } else {
      final row = {_databaseHelper.colData: jsonEncode(foodRecord)};
      await _databaseHelper.database.update(_databaseHelper.tblFoodRecord, row,
          where: '${_databaseHelper.colId} = ?', whereArgs: [foodRecord.id]);
    }
  }

  @override
  Future<List<FoodRecord>?> fetchDayRecords(
      {required DateTime dateTime}) async {
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
          foodRecord.createdAt?.toInt() ?? 0);
      final date = DateFormat('yyyyMMdd').format(createdAt);

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
      foodRecordResponse.id = e?[_databaseHelper.colId].toString();
      return foodRecordResponse;
    }).toList();
  }

  @override
  Future<void> deleteFavorite({required FoodRecord foodRecord}) async {
    await _databaseHelper.database.delete(_databaseHelper.tblFavorite,
        where: '${_databaseHelper.colId} = ?', whereArgs: [foodRecord.id]);
  }

  @override
  Future<void> updateUserProfile(
      {required UserProfileModel userProfile, required bool isNew}) async {
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
      return UserProfileModel.fromJson(
          jsonDecode(data?[_databaseHelper.colData]));
    }
    return null;
  }
}
