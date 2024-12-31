import 'package:flutter/foundation.dart';
import 'package:speech_to_text/speech_recognition_error.dart' as stt;
import 'package:speech_to_text/speech_to_text.dart' as stt;

typedef StatusListener = Function(String status);
typedef ErrorListener = Function(String status, bool permanent);
typedef RecognizeListener = Function(String text);

abstract class SpeechToTextUtility {
  /// Initializes the speech-to-text utility.
  Future<bool> initialize({
    StatusListener? statusListener,
    ErrorListener? errorListener,
    Duration? timeout,
  });

  /// Starts listening for speech input.
  void startListening({
    RecognizeListener? recognizeListener,
    stt.ListenMode listenMode = stt.ListenMode.confirmation,
  });

  /// Stops listening for speech input.
  Future<void> stopListening();

  /// Disposes of resources used by the speech-to-text utility.
  Future<void> dispose();

  /// Sets a custom status listener.
  void setStatusListener(StatusListener? listener);

  /// Sets a custom error listener.
  void setErrorListener(ErrorListener? listener);

  /// Fetches the list of available locales.
  Future<List<stt.LocaleName>> getLocales();

  /// Sets the current locale for speech recognition.
  Future<bool> setLocale(String locale);
}

class SpeechToTextUtilityImpl extends SpeechToTextUtility {
  // Private constructor for singleton implementation.
  SpeechToTextUtilityImpl._() {
    _speech = stt.SpeechToText();
  }

  // Factory method for accessing the singleton instance.
  static final SpeechToTextUtilityImpl _instance = SpeechToTextUtilityImpl._();

  factory SpeechToTextUtilityImpl() => _instance;

  late stt.SpeechToText _speech;
  stt.LocaleName? _selectedLocale;

  @override
  Future<bool> initialize({
    StatusListener? statusListener,
    ErrorListener? errorListener,
    Duration? timeout,
  }) async {
    try {
      bool initialized = await _speech.initialize(
        onStatus: statusListener,
        onError: (e) => _handleError(e, errorListener),
        debugLogging: kDebugMode,
        finalTimeout: timeout ?? const Duration(milliseconds: 2000),
      );
      return initialized;
    } on Exception catch (e) {
      errorListener?.call(e.toString(), false);
      return false;
    }
  }

  @override
  Future<void> startListening({
    RecognizeListener? recognizeListener,
    stt.ListenMode listenMode = stt.ListenMode.confirmation,
  }) async {
    if (!_speech.isAvailable) {
      throw Exception('Speech-to-text is not available.');
    }
    await _speech.listen(
      localeId: _selectedLocale?.localeId,
      listenOptions: stt.SpeechListenOptions(listenMode: listenMode),
      onResult: (result) {
        recognizeListener?.call(result.recognizedWords);
      },
    );
  }

  @override
  Future<void> stopListening() async {
    if (_speech.isListening) {
      return _speech.stop();
    }
    return;
  }

  @override
  Future<void> dispose() async {
    await _speech.cancel();
    _speech.statusListener = null;
    _speech.errorListener = null;
  }

  @override
  void setStatusListener(StatusListener? listener) {
    _speech.statusListener ??= listener;
  }

  @override
  void setErrorListener(ErrorListener? listener) {
    _speech.errorListener ??= (e) {
      _handleError(e, listener);
    };
  }

  @override
  Future<List<stt.LocaleName>> getLocales() async {
    return _speech.locales();
  }

  @override
  Future<bool> setLocale(String locale) async {
    final locales = await getLocales();
    _selectedLocale = locales.cast<stt.LocaleName?>().firstWhere(
          (localeName) {
        if (localeName?.localeId.contains('-') ?? false) {
          return localeName?.localeId.substring(
              0, localeName.localeId.indexOf('-')) == locale;
        }
        return localeName?.name == locale;
      },
      orElse: () {
        return null;
      },
    );
    return _selectedLocale != null;
  }

  // Private helper for error handling (optional).
  void _handleError(stt.SpeechRecognitionError e, ErrorListener? errorListener) {
    errorListener?.call(e.toString(), false);
  }
}
