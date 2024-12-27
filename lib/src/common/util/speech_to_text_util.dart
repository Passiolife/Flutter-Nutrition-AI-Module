import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

typedef StatusListener = Function(String status);
typedef ErrorListener = Function(String status);

class SpeechToTextUtil {
  late stt.SpeechToText _speech;

  SpeechToTextUtil._() {
    _speech = stt.SpeechToText();
  }

  static SpeechToTextUtil get _instance => SpeechToTextUtil._();

  static SpeechToTextUtil get instance => _instance;

  stt.LocaleName? _selectedLocale;

  Future<bool> initialize({
    StatusListener? statusListener,
    ErrorListener? errorListener,
    Duration? timeout,
  }) async {
    try {
      bool initialized = await _speech.initialize(
        onStatus: statusListener,
        onError: (e) => errorListener?.call(e.errorMsg),
        debugLogging: kDebugMode,
        finalTimeout: timeout ?? const Duration(milliseconds: 2000),
      );
      setStatusListener(statusListener);
      setErrorListener(errorListener);
      return initialized;
    } on Exception {
      return false;
    }
  }

  void startListening(
      {Function(String)? recognizedWords, bool finalResult = true}) async {
    await _speech.listen(
      localeId: _selectedLocale?.localeId,
      listenOptions:
          stt.SpeechListenOptions(listenMode: stt.ListenMode.dictation),
      onResult: (result) {
        log(result.recognizedWords);
        recognizedWords?.call(result.recognizedWords);
        return;
      },
    );
  }

  void stopListening() async {
    if (_speech.isListening) {
      await _speech.stop();
    }
  }

  Future<void> cancel() async {
    await _speech.cancel();
    _speech.statusListener = null;
    _speech.errorListener = null;
  }

  void setStatusListener(StatusListener? listener) {
    _speech.statusListener ??= listener;
  }

  void setErrorListener(ErrorListener? listener) {
    _speech.errorListener ??= (e) {
      listener?.call(e.errorMsg);
    };
  }

  // Locale related
  Future<List<stt.LocaleName>> getLocales() async {
    return await _speech.locales();
  }

  Future<bool> setLocale(String? locale) async {
    final locales = await getLocales();
    _selectedLocale = locales.cast<stt.LocaleName?>().firstWhere(
      (localeName) {
        return localeName?.name == locale;
      },
      orElse: () {
        return null;
      },
    );
    return _selectedLocale != null;
  }
}
