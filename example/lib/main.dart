import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:nutrition_ai_module/nutrition_ai_module.dart';

import 'src/models/app_secret/app_secret.dart';
import 'src/util/date_time_utility.dart';

String foodRecordBoxName = 'foodRecordBox';
String userProfileBoxName = 'userProfileBox';
String favoriteBoxName = 'favoriteBox';
String waterRecordBoxName = 'waterBox';
String weightRecordBoxName = 'weightBox';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize hive
  await Hive.initFlutter();

  // Registering the adapters
  Hive
    ..registerAdapter(FoodRecordAdapter())
    ..registerAdapter(UserProfileAdapter())
    ..registerAdapter(WaterRecordAdapter())
    ..registerAdapter(WeightRecordAdapter());

  // Opening Hive boxes
  await Future.wait([
    Hive.openBox<FoodRecord>(foodRecordBoxName),
    Hive.openBox<UserProfileModel?>(userProfileBoxName),
    Hive.openBox<FoodRecord>(favoriteBoxName),
    Hive.openBox<WaterRecord>(waterRecordBoxName),
    Hive.openBox<WeightRecord>(weightRecordBoxName),
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ValueNotifier<PassioStatus?> _passioStatus = ValueNotifier(null);

  @override
  void initState() {
    _initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder<PassioStatus?>(
        valueListenable: _passioStatus,
        builder: (context, value, child) {
          return Center(
            child: value == null
                ? const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      Text("Configuring SDK"),
                    ],
                  )
                : value.mode == PassioMode.isReadyForDetection
                    ? ElevatedButton(
                        onPressed: () async {
                          await NutritionAIModule.instance
                              .setPassioConnector(
                                  MyPassioConnector()) // This is optional
                              .launch(context);
                        },
                        child: const Text('Launch'),
                      )
                    : Text(value.mode.name),
          );
        },
      ),
    );
  }

  void _initialize() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      final passioConfig = PassioConfiguration(AppSecret.passioKey);
      NutritionAI.instance.configureSDK(passioConfig).then((value) async {
        _passioStatus.value = value;
      });
    });
  }
}

class MyPassioConnector implements PassioConnector {
  /// [_foodRecordBox] helps to stores the food record data inside the hive db.
  ///
  late Box<FoodRecord> _foodRecordBox;

  /// [_userProfileBox] helps to stores the user profile data inside the hive db.
  ///
  Box<UserProfileModel?>? _userProfileBox;

  /// [_favoriteBox] helps to stores the favorite data inside the hive db.
  ///
  Box<FoodRecord>? _favoriteBox;

  late Box<WaterRecord> _waterRecordBox;
  late Box<WeightRecord> _weightRecordBox;

  MyPassioConnector() {
    // Get reference to an already opened box
    _foodRecordBox = Hive.box<FoodRecord>(foodRecordBoxName);
    _userProfileBox = Hive.box<UserProfileModel?>(userProfileBoxName);
    _favoriteBox = Hive.box<FoodRecord>(favoriteBoxName);
    _waterRecordBox = Hive.box<WaterRecord>(waterRecordBoxName);
    _weightRecordBox = Hive.box<WeightRecord>(weightRecordBoxName);
  }

  // User Profile Methods

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

  // Record Methods

  @override
  Future<List<FoodRecord>> fetchDayRecords({required DateTime dateTime}) async {
    // _foodRecords =
    return _foodRecordBox.values
        .toList()
        .asMap()
        .entries
        .map((e) {
          e.value.id = e.key.toString();
          return e.value;
        })
        .where((element) {
          String createdAt = DateFormat('yyyyMMdd')
              .format(element.getCreatedAt() ?? DateTime.now());
          String date = DateFormat('yyyyMMdd').format(dateTime);
          return createdAt == date;
        })
        .toList()
        .reversed
        .toList();
  }

  @override
  Future<List<FoodRecord>> fetchRecords({
    required DateTime fromDate,
    required DateTime endDate,
  }) async {
    return _foodRecordBox.values
        .toList()
        .asMap()
        .entries
        .map((e) {
          e.value.id = e.key.toString();
          return e.value;
        })
        .where((element) {
          return element
                  .getCreatedAt()
                  ?.isBetween(from: fromDate, to: endDate) ??
              false;
        })
        .toList()
        .reversed
        .toList();
  }

  @override
  Future<void> updateRecord({
    required FoodRecord foodRecord,
    required bool isNew,
  }) async {
    if (isNew) {
      await _foodRecordBox.add(foodRecord);
    } else {
      final key = int.tryParse(foodRecord.id);
      if (key != null) {
        await _foodRecordBox.putAt(key, foodRecord);
      }
    }
  }

  @override
  Future<void> deleteRecord({required FoodRecord foodRecord}) async {
    final key = int.tryParse(foodRecord.id);
    if (key != null) {
      await _foodRecordBox.deleteAt(key);
    }
  }

  // Favorite Methods

  @override
  Future<List<FoodRecord>?> fetchFavorites() async {
    return _favoriteBox?.values
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
  }

  @override
  Future<bool> favoriteExists({required FoodRecord foodRecord}) async {
    return _favoriteBox?.values.toList().cast<FoodRecord?>().firstWhere(
              (e) => e?.refCode == foodRecord.refCode,
              orElse: () => null,
            ) !=
        null;
  }

  @override
  Future<void> updateFavorite({
    required FoodRecord foodRecord,
    required bool isNew,
  }) async {
    if (isNew) {
      await _favoriteBox?.add(foodRecord);
    } else {
      final key = int.tryParse(foodRecord.id);
      if (key != null) {
        await _favoriteBox?.putAt(key, foodRecord);
      }
    }
  }

  @override
  Future<void> deleteFavorite({required FoodRecord foodRecord}) async {
    final key = int.tryParse(foodRecord.id);
    if (key != null) {
      await _favoriteBox?.deleteAt(key);
    }
  }

  // Water Methods

  @override
  Future<double> fetchConsumedWater({required DateTime dateTime}) async {
    return _waterRecordBox.values
        .toList()
        .asMap()
        .entries
        .map((e) {
          e.value.id = e.key;
          return e.value;
        })
        .where((element) {
          String createdAt = DateFormat('yyyyMMdd').format(
              DateTime.fromMillisecondsSinceEpoch(element.createdAt,
                  isUtc: true));
          String date = DateFormat('yyyyMMdd').format(dateTime);
          return createdAt == date;
        })
        .toList()
        .fold<double>(
            0, (previousValue, element) => previousValue + element.getWater());
  }

  @override
  Future<List<WaterRecord>> fetchWaterRecords({
    required DateTime fromDate,
    required DateTime endDate,
  }) async {
    return _waterRecordBox.values
        .toList()
        .asMap()
        .entries
        .map((e) {
          e.value.id = e.key;
          return e.value;
        })
        .where((element) {
          return DateTime.fromMillisecondsSinceEpoch(element.createdAt,
                  isUtc: true)
              .isBetween(from: fromDate, to: endDate);
        })
        .toList()
        .reversed
        .toList();
  }

  @override
  Future<void> updateWater({
    required WaterRecord waterRecord,
    required bool isNew,
  }) async {
    if (isNew) {
      await _waterRecordBox.add(waterRecord);
    } else {
      final key = waterRecord.id;
      if (key != null) {
        await _waterRecordBox.putAt(key, waterRecord);
      }
    }
  }

  @override
  Future<void> deleteWaterRecord({required WaterRecord record}) async {
    final key = record.id;
    if (key != null) {
      await _waterRecordBox.deleteAt(key);
    }
  }

  // Weight Methods

  @override
  Future<double> fetchMeasuredWeight({required DateTime dateTime}) async {
    return _weightRecordBox.values
        .toList()
        .asMap()
        .entries
        .map((e) {
          e.value.id = e.key;
          return e.value;
        })
        .where((element) {
          String createdAt = DateFormat('yyyyMMdd').format(
              DateTime.fromMillisecondsSinceEpoch(element.createdAt,
                  isUtc: true));
          String date = DateFormat('yyyyMMdd').format(dateTime);
          return createdAt == date;
        })
        .toList()
        .fold<double>(
            0, (previousValue, element) => previousValue + element.getWeight());
  }

  @override
  Future<List<WeightRecord>> fetchWeightRecords({
    required DateTime fromDate,
    required DateTime endDate,
  }) async {
    return _weightRecordBox.values
        .toList()
        .asMap()
        .entries
        .map((e) {
          e.value.id = e.key;
          return e.value;
        })
        .where((element) {
          return DateTime.fromMillisecondsSinceEpoch(
            element.createdAt,
            isUtc: true,
          ).isBetween(from: fromDate, to: endDate);
        })
        .toList()
        .reversed
        .toList();
  }

  @override
  Future<void> updateWeight({
    required WeightRecord record,
    required bool isNew,
  }) async {
    if (isNew) {
      await _weightRecordBox.add(record);
    } else {
      final key = record.id;
      if (key != null) {
        await _weightRecordBox.putAt(key, record);
      }
    }
  }

  @override
  Future<void> deleteWeightRecord({required WeightRecord record}) async {
    final key = record.id;
    if (key != null) {
      await _weightRecordBox.deleteAt(key);
    }
  }
}

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

class WaterRecordAdapter extends TypeAdapter<WaterRecord> {
  @override
  WaterRecord read(BinaryReader reader) {
    return WaterRecord.fromJson(jsonDecode(reader.read()));
  }

  @override
  int get typeId => 2;

  @override
  void write(BinaryWriter writer, WaterRecord obj) {
    return writer.write(jsonEncode(obj));
  }
}

class WeightRecordAdapter extends TypeAdapter<WeightRecord> {
  @override
  WeightRecord read(BinaryReader reader) {
    return WeightRecord.fromJson(jsonDecode(reader.read()));
  }

  @override
  int get typeId => 3;

  @override
  void write(BinaryWriter writer, WeightRecord obj) {
    return writer.write(jsonEncode(obj));
  }
}
