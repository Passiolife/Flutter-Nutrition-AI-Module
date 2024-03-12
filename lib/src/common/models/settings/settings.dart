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
}
