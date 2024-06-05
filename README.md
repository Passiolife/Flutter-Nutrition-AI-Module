# Passio Nutrition-AI-Module Flutter SDK

## Overview

Welcome to Passio Nutrition-AI-Module Flutter SDK!

This package provides a collection of pre-built pages, allowing users to effortlessly integrate
these pages into your Flutter app. With just a few simple steps, your app can benefit from these
ready-made features. Built to work with [nutrition_ai](https://pub.dev/packages/nutrition_ai).


## BEFORE YOU CONTINUE:

1. Passio Nutrition-AI SDK added data from Open Food Facts (https://en.openfoodfacts.org/). Each food that contains data from Open Food Facts will be marked by public var isOpenFood: Bool.. In case you choose to set ```isOpenFood = true``` you agree to abide by the terms of the Open Food Facts license agreement (https://opendatacommons.org/licenses/odbl/1-0) and their terms of use (https://world.openfoodfacts.org/terms-of-use) and you will have to add to the UI the following license copy:

"This record contains information from Open Food Facts (https://en.openfoodfacts.org), which is made available here under the Open Database License (https://opendatacommons.org/licenses/odbl/1-0)"

2. To use the SDK sign up at https://www.passio.ai/nutrition-ai. The SDK WILL NOT WORK without a valid SDK key.

## Minimum Requirements

|             | Android | iOS   |
|-------------|---------|-------|
| **Support** | SDK 26+ | 13.0+ |


### Required Permissions

The module needs the following permissions to work correctly:


#### Android

Add the following permissions to your `AndroidManifest.xml` file:

```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
<uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM" />

<application>
    <receiver android:exported="false" android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationReceiver" />
    <receiver android:exported="false" android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationBootReceiver">
        <intent-filter>
            <action android:name="android.intent.action.BOOT_COMPLETED"/>
            <action android:name="android.intent.action.MY_PACKAGE_REPLACED"/>
            <action android:name="android.intent.action.QUICKBOOT_POWERON" />
            <action android:name="com.htc.intent.action.QUICKBOOT_POWERON"/>
        </intent-filter>
    </receiver>
</application>
```

#### iOS

Add the following permissions to your `Info.plist` file:

```xml
<key>NSCameraUsageDescription</key>
<string>App requires your camera access to scan the food.</string>
<key>NSLocalNotificationUsageDescription</key>
<string>We use local notifications to remind you of meal times.</string>
```


### Setup for Android

* Add to top build.gradle file (Project: android)

```groovy
allprojects {
   repositories {
      ...
      flatDir {
         dirs project(':nutrition_ai').file('libs')
      }
   }
}
```

## Getting started

1. Add the dependency in `pubspec.yaml`:

```yaml
dependencies:
  nutrition_ai_module: ^3.1.0
```

## Usage

#### Note: Ensure your SDK is configured correctly before launching the Nutrition AI module.


2. Import the Passio Nutrition AI Module

```dart
import 'package:nutrition_ai_module/nutrition_ai_module.dart';
```

3. Insert the following line at the location of your choice to initiate the Nutrition AI Module.

```dart
await NutritionAIModule.instance
    .setPassioConnector(MyPassioConnector()) // This is optional
    .launch(context);
```

- **setPassioConnector(PassioConnector passioConnector):** To use this method, you must provide a `PassioConnector` as a parameter and ensure the implementation of all methods specified within the `PassioConnector`. By default, the data will be
  stored in the Local Database.

- **launch(BuildContext context):** In order to launch our module, this method requires a `BuildContext` as a parameter. You can call this method at your desired launch location, and it returns a `Future`.

4. PassioConnector
```dart
class MyPassioConnector implements PassioConnector {

  // User Profile Methods

  @override
  Future<UserProfileModel?> fetchUserProfile() async {
  }

  @override
  Future<void> updateUserProfile({
    required UserProfileModel userProfile,
    required bool isNew,
  }) async {
  }

  // Record Methods

  @override
  Future<List<FoodRecord>> fetchDayRecords({
    required DateTime dateTime,
  }) async {
  }

  @override
  Future<List<FoodRecord>> fetchRecords({
    required DateTime fromDate,
    required DateTime endDate,
  }) async {
  }

  @override
  Future<void> updateRecord({
    required FoodRecord foodRecord,
    required bool isNew,
  }) async {
  }
  
  @override
  Future<void> deleteRecord({
    required FoodRecord foodRecord,
  }) async {
  }
  
  // Favorite Methods

  @override
  Future<List<FoodRecord>?> fetchFavorites() async {
  }

  @override
  Future<bool> favoriteExists({
    required FoodRecord foodRecord,
  }) async {
  }

  @override
  Future<void> updateFavorite({
    required FoodRecord foodRecord,
    required bool isNew,
  }) async {
  }

  @override
  Future<void> deleteFavorite({
    required FoodRecord foodRecord,
  }) async {
  }

  // Water Methods

  @override
  Future<double> fetchConsumedWater({
    required DateTime dateTime,
  }) async {
  }

  @override
  Future<List<WaterRecord>> fetchWaterRecords({
    required DateTime fromDate,
    required DateTime endDate,
  }) async {
  }

  @override
  Future<void> updateWater({
    required WaterRecord waterRecord,
    required bool isNew,
  }) async {
  }

  @override
  Future<void> deleteWaterRecord({
    required WaterRecord record,
  }) async {
  }

  // Weight Methods

  @override
  Future<double> fetchMeasuredWeight({
    required DateTime dateTime,
  }) async {
  }

  @override
  Future<List<WeightRecord>> fetchWeightRecords({
    required DateTime fromDate,
    required DateTime endDate,
  }) async {
  }

  @override
  Future<void> updateWeight({
    required WeightRecord record,
    required bool isNew,
  }) async {
  }

  @override
  Future<void> deleteWeightRecord({
    required WeightRecord record,
  }) async {
  }
}
```

5. FoodRecord
```dart
class FoodRecord {
  String id = '';
  String passioID;
  String refCode;
  String name;
  String additionalData = '';
  String iconId = '';
  late List<FoodRecordIngredient> ingredients;
  String _selectedUnit = '';
  double _selectedQuantity = zeroQuantity;
  late List<PassioServingSize> servingSizes;
  late List<PassioServingUnit> servingUnits;
  PassioIDEntityType? entityType;
  MealLabel? mealLabel;
  int? _createdAt;
  String? openFoodLicense;
  static const zeroQuantity = 0.00001;
  bool isFavorite = false;
}
```

6. FoodRecordIngredient
```dart
class FoodRecordIngredient {
  String id = '';
  String passioID;
  String refCode;
  String name = '';
  String iconId = '';
  String selectedUnit = '';
  double selectedQuantity = 0;
  late List<PassioServingSize> servingSizes;
  late List<PassioServingUnit> servingUnits;
  PassioNutrients referenceNutrients;
  String? openFoodLicense;
  PassioIDEntityType entityType;
}
```

7. UserProfileModel
```dart
class UserProfileModel {
  String? id;
  String? name;
  int? _age;
  double? _weight;
  double _targetWeight;
  GenderSelection gender;
  MeasurementSystem heightUnit;
  MeasurementSystem weightUnit;
  double _targetWater;
  ActivityLevel? _activityLevel;
  double? _height;
  CalorieDeficit _calorieDeficit;
  PassioMealPlan? _mealPlan;
  int caloriesTarget = 2100;
  int carbsPercentage = 50;
  int proteinPercentage = 25;
  int fatPercentage = 25;
}
```

8. WaterRecord
```dart
class WaterRecord {
  int? id;
  double _waterConsumption;
  final int createdAt;
}
```
9. WeightRecord
```dart
class WeightRecord {
  int? id;
  double _weight;
  final int createdAt;
}
```

#### Note:

The default PassioConnector operates with the Local Database, which means the data can be lost when
the app is uninstalled. Therefore, it's your responsibility to store it in a more permanent location
if required.


## Customization

While our package offers a set of pre-built features, we understand that every app is unique. You
can easily customize it to match your specific requirements by referring to
the [nutrition_ai](https://pub.dev/packages/nutrition_ai) package for additional options.

## Guideline to report an issue/feature request

It would be great for us if the reporter could share the below things to understand the root cause
of the issue.

- Library version
- Code snippet
- Logs if applicable
- Device specification like (Manufacturer, OS version, etc)
- Screenshot/video with steps to reproduce the issue

<sup>Copyright 2024 Passio Inc</sup>