This package provides a collection of pre-built pages, allowing users to effortlessly integrate these pages into your Flutter app. With just a few simple steps, your app can benefit from these ready-made features. Built to work with [nutrition_ai](https://pub.dev/packages/nutrition_ai).

## Features
| Quick Scan | Multi Food Scan | Food Search |
|-------------|---------|-------|
| <video src="https://github.com/Passiolife/Flutter-Nutrition-AI-Module/assets/84432215/bff54089-6636-4be5-8c81-51eccb09fb5e"> | <video src="https://github.com/Passiolife/Flutter-Nutrition-AI-Module/assets/84432215/8932ce98-1a37-46df-82c2-af8d9eac0d24"> | <video src="https://github.com/Passiolife/Flutter-Nutrition-AI-Module/assets/84432215/301771a3-0663-4d35-a250-dfd1a6d2fc71"> |
| This page enables you to scan real-time food items using your camera. | Capability to Scan multiple food items in real-time using your camera. | Input the name of a food item, and it will display matched results from the SDK. |



## BEFORE YOU CONTINUE:

1. Passio Nutrition-AI SDK added data from Open Food Facts (https://en.openfoodfacts.org/). Each food that contains data from Open Food Facts will be marked by public var isOpenFood: Bool.. In case you choose to set ```isOpenFood = true``` you agree to abide by the terms of the Open Food Facts license agreement (https://opendatacommons.org/licenses/odbl/1-0) and their terms of use (https://world.openfoodfacts.org/terms-of-use) and you will have to add to the UI the following license copy:

"This record contains information from Open Food Facts (https://en.openfoodfacts.org), which is made available here under the Open Database License (https://opendatacommons.org/licenses/odbl/1-0)"

2. To use the SDK sign up at https://www.passio.ai/nutrition-ai. The SDK WILL NOT WORK without a valid SDK key.

3. This module is predefined set of widgets so if you want to make customization then you can take a look at the nutrition_ai package.

## Minimum Requirements

|             | Android | iOS   |
|-------------|---------|-------|
| **Support** | SDK 26+ | 13.0+ |

> **_NOTE:_** The SDK requires access to the devices's camera.

### Setup for Android

* Add to top `build.gradle` file (Project: android)

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
  nutrition_ai_module: ^0.0.1
```


## Usage

2. Import the Passio Nutrition AI Module

```dart
import 'package:nutrition_ai_module/nutrition_ai_module.dart';
```

3. Insert the following line at the location of your choice to initiate the Nutrition AI Module.
```dart
await NutritionAIModule.instance.setPassioKey(PUT_YOUR_PASSIO_KEY_HERE).setPassioConnector(this).launch(context);
```

#### Required Methods:

##### setPassioKey(String key):
This method requires a string value as a parameter, so please provide the Key you acquired upon signing up at https://www.passio.ai/nutrition-ai.

##### launch(BuildContext context):
In order to launch our module, this method requires a `BuildContext` as a parameter. You can call this method at your desired launch location, and it returns a `Future`.

#### Optional Methods:

##### setPassioConnector(PassioConnector passioConnector):
To use this method, you must provide a `PassioConnector` as a parameter and ensure the implementation of all methods specified within the `PassioConnector`. By default, the data will be stored in the LocalDatabase.


#### Note:
The default PassioConnector operates with the Local Database, which means the data can be lost when the app is uninstalled. Therefore, it's your responsibility to store it in a more permanent location if required.

## Customization

While our package offers a set of pre-built features, we understand that every app is unique. You can easily customize it to match your specific requirements by referring to the [nutrition_ai](https://pub.dev/packages/nutrition_ai) package for additional options.

## Guideline to report an issue/feature request
It would be great for us if the reporter could share the below things to understand the root cause of the issue.
- Library version
- Code snippet
- Logs if applicable
- Device specification like (Manufacturer, OS version, etc)
- Screenshot/video with steps to reproduce the issue

<sup>Copyright 2023 Passio Inc</sup>