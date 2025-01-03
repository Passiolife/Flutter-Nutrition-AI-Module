import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppBorderCircular {
  AppBorderCircular._();

  /// Border circular all
  static BorderRadius ba8 = BorderRadius.all(Radius.circular(8.r));
  static BorderRadius ba10 = BorderRadius.all(Radius.circular(10.r));
  static BorderRadius ba16 = BorderRadius.all(Radius.circular(16.r));

  /// Border circular top only
  static BorderRadius bt16 = BorderRadius.vertical(top: Radius.circular(16.r));

  /// Border circular bottom only
  static BorderRadius bb16 = BorderRadius.vertical(bottom: Radius.circular(16.r));
}