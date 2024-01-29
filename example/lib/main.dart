import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:nutrition_ai_module/nutrition_ai_module.dart';

String foodRecordBoxName = 'foodRecordBox';
String userProfileBoxName = 'userProfileBox';
String favoriteBoxName = 'favoriteBox';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize hive
  await Hive.initFlutter();
  // Registering the adapter
  Hive.registerAdapter(FoodRecordAdapter());
  Hive.registerAdapter(UserProfileAdapter());
  // Open the foodRecordBox
  await Hive.openBox<FoodRecord>(foodRecordBoxName);
  // Open the userProfileBox
  await Hive.openBox<UserProfileModel?>(userProfileBoxName);
  // Open the favoriteBox
  await Hive.openBox<FoodRecord>(favoriteBoxName);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Nutrition AI Module Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> implements PassioConnector {
  /// [_foodRecordBox] helps to stores the food record data inside the hive db.
  ///
  Box<FoodRecord>? _foodRecordBox;

  /// [_userProfileBox] helps to stores the user profile data inside the hive db.
  ///
  Box<UserProfileModel?>? _userProfileBox;

  /// [_favoriteBox] helps to stores the favorite data inside the hive db.
  ///
  Box<FoodRecord>? _favoriteBox;

  /// [_foodRecords] contains the food record list.
  ///
  List<FoodRecord>? _foodRecords;

  /// [_favoriteRecords] contains the favorite record list.
  ///
  List<FoodRecord>? _favoriteRecords;

  @override
  void initState() {
    // Get reference to an already opened box
    _foodRecordBox = Hive.box(foodRecordBoxName);
    _userProfileBox = Hive.box(userProfileBoxName);
    _favoriteBox = Hive.box(favoriteBoxName);
    super.initState();
  }

  @override
  void dispose() {
    // Closes all Hive boxes
    Hive.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await NutritionAIModule.instance
                .setPassioKey('9xL917n5RlTHhNttWTE4PQ6y7sdzD3mJWxJ36duPvL1Y')
                .setPassioConnector(this) // This is optional
                .launch(context);
          },
          child: const Text('Launch'),
        ),
      ),
    );
  }

  @override
  Future<List<FoodRecord>?> fetchDayRecords(
      {required DateTime dateTime}) async {
    _foodRecords = _foodRecordBox?.values
        .toList()
        .asMap()
        .entries
        .map((e) {
          e.value.id = e.key.toString();
          return e.value;
        })
        .where((element) {
          String createdAt = DateFormat('yyyyMMdd').format(
              DateTime.fromMillisecondsSinceEpoch(
                  element.createdAt?.toInt() ?? 0));
          String date = DateFormat('yyyyMMdd').format(dateTime);
          return createdAt == date;
        })
        .toList()
        .reversed
        .toList();
    return _foodRecords;
  }

  @override
  Future<void> updateRecord(
      {required FoodRecord foodRecord, required bool isNew}) async {
    if (isNew) {
      await _foodRecordBox?.add(foodRecord);
    } else {
      final key = int.tryParse(foodRecord.id ?? '');
      if (key != null) {
        await _foodRecordBox?.putAt(key, foodRecord);
      }
    }
  }

  @override
  Future<void> deleteRecord({required FoodRecord foodRecord}) async {
    final key = int.tryParse(foodRecord.id ?? '');
    if (key != null) {
      await _foodRecordBox?.deleteAt(key);
    }
  }

  /// Methods related to favorites.
  ///
  @override
  Future<List<FoodRecord>?> fetchFavorites() async {
    _favoriteRecords = _favoriteBox?.values
        .toList()
        .asMap()
        .entries
        .map((e) {
          e.value.id = e.key.toString();
          return e.value;
        })
        .toList()
        .reversed
        .toList();
    return _favoriteRecords;
  }

  @override
  Future<void> updateFavorite(
      {required FoodRecord foodRecord, required bool isNew}) async {
    if (isNew) {
      await _favoriteBox?.add(foodRecord);
    } else {
      final key = int.tryParse(foodRecord.id ?? '');
      if (key != null) {
        await _favoriteBox?.putAt(key, foodRecord);
      }
    }
  }

  @override
  Future<void> deleteFavorite({required FoodRecord foodRecord}) async {
    final key = int.tryParse(foodRecord.id ?? '');
    if (key != null) {
      await _favoriteBox?.deleteAt(key);
    }
  }

  /// Methods related to UserProfile.
  ///
  @override
  Future<UserProfileModel?> fetchUserProfile() async {
    return _userProfileBox?.values.firstOrNull;
  }

  @override
  Future<void> updateUserProfile(
      {required UserProfileModel userProfile, required bool isNew}) async {
    if (isNew) {
      await _userProfileBox?.add(userProfile);
    } else {
      await _userProfileBox?.putAt(
          _userProfileBox?.keys.firstOrNull, userProfile);
    }
  }
}

/// Declaring the Type Adapters for Hive.
///

class FoodRecordAdapter extends TypeAdapter<FoodRecord> {
  @override
  FoodRecord read(BinaryReader reader) {
    return FoodRecord.fromJson(jsonDecode(reader.read()));
  }

  @override
  int get typeId => 0;

  @override
  void write(BinaryWriter writer, FoodRecord obj) {
    writer.write(jsonEncode(obj));
  }
}

class UserProfileAdapter extends TypeAdapter<UserProfileModel> {
  @override
  UserProfileModel read(BinaryReader reader) {
    return UserProfileModel.fromJson(jsonDecode(reader.read()));
  }

  @override
  int get typeId => 1;

  @override
  void write(BinaryWriter writer, UserProfileModel obj) {
    return writer.write(jsonEncode(obj));
  }
}
