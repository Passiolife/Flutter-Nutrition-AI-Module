import 'dart:convert';

import 'package:flutter/services.dart';

class AppLocalizations {
  /// Here, implementing the code for singleton class.
  static final AppLocalizations _instance =
      AppLocalizations._privateConstructor();

  AppLocalizations._privateConstructor();

  static AppLocalizations get instance => _instance;

  Map<String, dynamic>? _localeData;

  Future<void> loadLanguageFile(String filePath) async {
    final String response = await rootBundle.loadString(filePath);
    _localeData = await json.decode(response);
  }

  /// Retrieve the language translation
  /// name: Component name
  String? getLabel(String name) {
    return (_localeData?.containsKey(name) ?? false)
        ? _localeData![name]
        : null;
  }

  String? get scanningForFood => getLabel('scanningForFood');

  String? get detected => getLabel('detected');

  String? get nutrition => getLabel('nutrition');

  String? get calories => getLabel('calories');

  String? get carbs => getLabel('carbs');

  String? get day => getLabel('day');

  String? get week => getLabel('week');

  String? get month => getLabel('month');

  String? get fat => getLabel('fat');

  String? get protein => getLabel('protein');

  String? get target => getLabel('target');

  String? get m => getLabel('m');

  String? get ft => getLabel('ft');

  String? get kg => getLabel('kg');

  String? get lb => getLabel('lb');

  String? get female => getLabel('female');

  String? get male => getLabel('male');

  String? get other => getLabel('other');

  String? get imperial => getLabel('imperial');

  String? get metric => getLabel('metric');

  String? get typeIn => getLabel('typeIn');

  String? get yourProfile => getLabel('yourProfile');

  String? get height => getLabel('height');

  String? get select => getLabel('select');

  String? get dailyCalories => getLabel('dailyCalories');

  String? get gender => getLabel('gender');

  String? get units => getLabel('units');

  String? get dailyMacroTarget => getLabel('dailyMacroTarget');

  String? get ok => getLabel('ok');

  String? get logout => getLabel('logout');

  String? get cancel => getLabel('cancel');

  String? get save => getLabel('save');

  String? get permission => getLabel('permission');

  String? get cameraPermissionMessage => getLabel('cameraPermissionMessage');

  String? get logSuccessMessage => getLabel('logSuccessMessage');

  String? get recipeAddedMessage => getLabel('recipeAddedMessage');

  String? get clear => getLabel('clear');

  String? get newRecipe => getLabel('newRecipe');

  String? get addAll => getLabel('addAll');

  String? get newRecipeTitle => getLabel('newRecipeTitle');

  String? get newRecipeHint => getLabel('newRecipeHint');

  String? get recipeNameErrorMessage => getLabel('recipeNameErrorMessage');

  String? get keepTyping => getLabel('keepTyping');

  String? get searching => getLabel('searching');

  String? get noFoodSearchResultMessage =>
      getLabel('noFoodSearchResultMessage');

  String? get myFavorites => getLabel('myFavorites');

  String? get back => getLabel('back');

  String? get delete => getLabel('delete');

  String? get noFavoriteTitle => getLabel('noFavoriteTitle');

  String? get noFavoriteDescription => getLabel('noFavoriteDescription');

  String? get favoriteSuccessMessage => getLabel('favoriteSuccessMessage');

  String? get favorites => getLabel('favorites');

  String? get favoriteDialogTitle => getLabel('favoriteDialogTitle');

  String? get my => getLabel('my');

  String? get allDay => getLabel('allDay');

  String? get breakfast => getLabel('breakfast');

  String? get lunch => getLabel('lunch');

  String? get dinner => getLabel('dinner');

  String? get snack => getLabel('snack');

  String? get profile => getLabel('profile');

  String? get quickFoodScan => getLabel('quickFoodScan');

  String? get multiFoodScan => getLabel('multiFoodScan');

  String? get byTextSearch => getLabel('byTextSearch');

  String? get fromFavorites => getLabel('fromFavorites');

  String? get addItem => getLabel('addItem');

  String? get more => getLabel('more');

  String? get edit => getLabel('edit');

  String? get noFoodInLog => getLabel('noFoodInLog');

  String? get today => getLabel('today');

  String? get menu => getLabel('menu');

  String? get signIn => getLabel('signIn');

  String? get forgotPassword => getLabel('forgotPassword');

  String? get password => getLabel('password');

  String? get email => getLabel('email');

  String? get enterValidEmailAddress => getLabel('enterValidEmailAddress');

  String? get enterValidPassword => getLabel('enterValidPassword');

  String? get acceptSignUp => getLabel('acceptSignUp');

  String? get termsOfService => getLabel('termsOfService');

  String? get privacyPolicy => getLabel('privacyPolicy');

  String? get youHaveReadThePrivacyPolicy =>
      getLabel('youHaveReadThePrivacyPolicy');

  String? get signUp => getLabel('signUp');

  String? get configuringSDK => getLabel('configuringSDK');

  String? get editAmount => getLabel('editAmount');

  String? get ingredients => getLabel('ingredients');

  String? get visualAlternatives => getLabel('visualAlternatives');

  String? get renameFoodRecord => getLabel('renameFoodRecord');

  // Redesign
  String? get welcome => getLabel('welcome');

  String? get dailyNutrition => getLabel('dailyNutrition');

  String? get weeklyAdherence => getLabel('weeklyAdherence');

  String? get thisWeek => getLabel('thisWeek');

  String? get water => getLabel('water');

  String? get oz => getLabel('oz');

  String? get remainToDailyGoal => getLabel('remainToDailyGoal');

  String? get weight => getLabel('weight');

  String? get lbs => getLabel('lbs');

  String? get remainToLoss => getLabel('remainToLoss');

  String? get progress => getLabel('progress');

  String? get myProfile => getLabel('myProfile');

  String? get tutorials => getLabel('tutorials');

  String? get settings => getLabel('settings');

  String? get home => getLabel('home');

  String? get diary => getLabel('diary');

  String? get mealPlan => getLabel('mealPlan');

  String? get recipes => getLabel('recipes');

  String? get favourite => getLabel('favourite');

  String? get search => getLabel('search');

  String? get scan => getLabel('scan');

  String? get foodScanner => getLabel('foodScanner');

  String? get foodScanIntroTitle => getLabel('foodScanIntroTitle');

  String? get foodScanIntroDescription => getLabel('foodScanIntroDescription');

  String? get foods => getLabel('foods');

  String? get beverages => getLabel('beverages');

  String? get packaging => getLabel('packaging');

  String? get nutritionFacts => getLabel('nutritionFacts');

  String? get barcodes => getLabel('barcodes');

  String? get log => getLabel('log');

  String? get notWhatYouAreLookingFor => getLabel('notWhatYouAreLookingFor');

  String? get searchManually => getLabel('searchManually');

  String? get itemAddedToDiary => getLabel('itemAddedToDiary');

  String? get itemAddedToDiaryDescription =>
      getLabel('itemAddedToDiaryDescription');

  String? get or => getLabel('or');

  String? get viewDiary => getLabel('viewDiary');

  String? get continueScanning => getLabel('continueScanning');

  String? get barcodeNotRecognized => getLabel('barcodeNotRecognized');

  String? get tryScanningNutritionFactsInstead =>
      getLabel('tryScanningNutritionFactsInstead');

  String? get scanNutritionFacts => getLabel('scanNutritionFacts');

  String? get scannedNutritionFacts => getLabel('scannedNutritionFacts');

  String? get scannedNutritionFactsDescription =>
      getLabel('scannedNutritionFactsDescription');

  String? get servingSize => getLabel('servingSize');

  String? get next => getLabel('next');

  String? get nameYourFood => getLabel('nameYourFood');

  String? get nameYourFoodDescription => getLabel('nameYourFoodDescription');

  String? get enterAName => getLabel('enterAName');

  String? get pleaseEnterAName => getLabel('pleaseEnterAName');

  String? get editFood => getLabel('editFood');

  String? get replace => getLabel('replace');

  String? get myDiary => getLabel('myDiary');

  String? get scanning => getLabel('scanning');

  String? get scanningDescription => getLabel('scanningDescription');

  String? get scanResults => getLabel('scanResults');

  String? get scanResultsDescription => getLabel('scanResultsDescription');

  String? get mealTime => getLabel('mealTime');

  String? get date => getLabel('date');

  String? get addIngredient => getLabel('addIngredient');

  String? get addedToFavorites => getLabel('addedToFavorites');

  String? get favourites => getLabel('favourites');

  String? get textSearch => getLabel('textSearch');

  String? get cal => getLabel('cal');

  String? get g => getLabel('g');

  String? get openFoodFacts => getLabel('openFoodFacts');

  String? get moreDetails => getLabel('moreDetails');
}
