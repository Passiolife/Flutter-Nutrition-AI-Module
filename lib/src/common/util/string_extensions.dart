import 'dart:convert';

import 'regexp.dart';

extension Util on String? {
  bool get isNullOrEmpty => this == null || this!.isEmpty;

  bool get isNotNullOrEmpty => !isNullOrEmpty;

  bool get isBlank => this == null || this!.trim().isEmpty;

  bool get isNotBlank => !isBlank;

  bool get isNullOrBlank => this == null || isBlank;

  bool get isNotNullOrBlank => !isNullOrBlank;

  bool isMinLength(int length) => (this?.length ?? 0) <= length;

  bool isEqualLength(int length) => (this?.length ?? 0) == length;

  bool get isValidEmail => RegExps.email.hasMatch(this ?? '');

  bool get isValidPassword => RegExps.password.hasMatch(this ?? '');

  String get toTitleCase => isBlank ? '' : '${this![0].toUpperCase()}${this!.substring(1)}';

  String get toBase64 => base64.encode(utf8.encode(this ?? ''));

  bool get containsLowerCase => RegExp(r"(?=.*[a-z])").hasMatch(this ?? '');

  bool get containsUpperCase => RegExp(r"(?=.*[A-Z])").hasMatch(this ?? '');

  bool get containsNumbers => RegExp(r"[0-9]").hasMatch(this ?? '');

  bool get containsSymbol => RegExp(r"[$&+,:;=?@#|'<>.^*()%!-]").hasMatch(this ?? '');

  String? toCapitalized() => (this?.length ?? 0) > 0 ? '${this?[0].toUpperCase()}${this?.substring(1).toLowerCase()}' : '';

  String getUppercaseFromString(int numberOfCharacters) {
    String upperString = '';
    if (this != null) {
      String? text = this?.replaceAll(' ', '');
      for (int i = 0; i < (text?.length ?? 0); i++) {
        if (isUpperCase(text![i])) {
          upperString += text[i];
        }
        if (numberOfCharacters == upperString.length) {
          break;
        }
      }
    }
    return upperString;
  }

  String get toUpperCaseWord => this?.split(" ").map((str) => str.toTitleCase).join(" ") ?? '';

  bool isUpperCase(String value) {
    return value == value.toUpperCase();
  }

  /// replace is work best rather to call multiple times replace method.
  /// findList: is a collection of string which you want to find in string for the replace purpose.
  /// replaceList: is a collection of string which you want to replace in string where the findList founds.
  /// replaceString: if your [replaceList] is null then replace string will assign at everyplace in findList.
  ///
  String? replace({required List<String> findList, List<String>? replaceList, String replaceString = ''}) {
    String? replacedString = this;
    findList.asMap().forEach((key, value) {
      if (replaceList != null && replaceList.isNotEmpty) {
        replacedString = replacedString?.replaceAll(value, replaceList[key]);
      } else {
        replacedString = replacedString?.replaceAll(value, replaceString);
      }
    });
    return replacedString;
  }

  String? format(List<String> params) => interpolate(this, params);

  String interpolate(String? string, List<String> params) {
    String? result = string;
    for (int i = 1; i < params.length + 1; i++) {
      result = result?.replaceAll('%s', params[i - 1]);
    }
    for (int i = 1; i < params.length + 1; i++) {
      result = result?.replaceAll('%$i\$', params[i - 1]);
    }
    return result ?? '';
  }

  String getNumber() {
    return this?.replaceAll(RegExp(r'[^0-9]'), '') ?? '';
  }

  String? getFileExtension() {
    try {
      if (this?.split('.').isNotEmpty ?? false) {
        return ".${this!.split('.').last}";
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
