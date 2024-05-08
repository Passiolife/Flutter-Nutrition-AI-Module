import '../../util/preference_store.dart';

// Class for managing app settings using SharedPreferences
class Settings {
  // Singleton instance of the Settings class
  static final Settings _instance = Settings._privateConstructor();

  // Private constructor for singleton pattern
  Settings._privateConstructor();

  // Getter for accessing the singleton instance
  static Settings get instance => _instance;

  // Reference to the PreferenceStore instance for storing settings
  final PreferenceStore _preferenceStore = PreferenceStore.instance;

  // Key for the intro seen setting
  static const String _scanIntroSeenKey = 'intro_seen';
  static const String _dragIntroSeenKey = 'intro_seen';

  // Key for the reminder notifications setting
  static const String _breakfastReminder = 'reminder_breakfast';
  static const String _lunchReminder = 'reminder_lunch';
  static const String _dinnerReminder = 'reminder_dinner';

  // Method to get the value of the intro seen setting
  // If the setting is not found, return false as default value
  bool getScanIntroSeen() {
    return _preferenceStore.getValue<bool>(_scanIntroSeenKey, false);
  }

  // Method to set the value of the intro seen setting
  void setScanIntroSeen(bool value) {
    _preferenceStore.setValue(_scanIntroSeenKey, value);
  }

  bool getDragIntroSeen() {
    return _preferenceStore.getValue<bool>(_dragIntroSeenKey, false);
  }

  void setDragIntroSeen(bool value) {
    _preferenceStore.setValue(_dragIntroSeenKey, value);
  }

  void setBreakfastReminder(bool value) {
    return _preferenceStore.setValue(_breakfastReminder, value);
  }

  bool getBreakfastReminder() {
    return _preferenceStore.getValue<bool>(_breakfastReminder, false);
  }

  void setLunchReminder(bool value) {
    return _preferenceStore.setValue(_lunchReminder, value);
  }

  bool getLunchReminder() {
    return _preferenceStore.getValue<bool>(_lunchReminder, false);
  }

  void setDinnerReminder(bool value) {
    return _preferenceStore.setValue(_dinnerReminder, value);
  }

  bool getDinnerReminder() {
    return _preferenceStore.getValue<bool>(_dinnerReminder, false);
  }
}
