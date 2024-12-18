import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_border.dart';

class AppPadding {
  AppPadding._();

  /// Padding All
  static EdgeInsets pa8 = EdgeInsets.all(8.r);
  static EdgeInsets pa16 = EdgeInsets.all(16.r);

  /// Padding Left
  static EdgeInsets pl8 = EdgeInsets.only(left: 8.w);

  /// Padding Right
  static EdgeInsets pr16 = EdgeInsets.only(right: 16.w);

  /// Padding Top
  static EdgeInsets pt8 = EdgeInsets.only(top: 8.h);
  static EdgeInsets pt16 = EdgeInsets.only(top: 16.h);

  /// Padding Bottom
  static EdgeInsets pb8 = EdgeInsets.only(bottom: 8.h);
  static EdgeInsets pb16 = EdgeInsets.only(bottom: 16.h);
  static EdgeInsets pb32 = EdgeInsets.only(bottom: 32.h);

  /// Vertical Padding
  static EdgeInsets pv4 = EdgeInsets.symmetric(vertical: 4.h);
  static EdgeInsets pv8 = EdgeInsets.symmetric(vertical: 8.h);
  static EdgeInsets pv16 = EdgeInsets.symmetric(vertical: 16.h);

  /// Horizontal Padding
  static EdgeInsets ph8 = EdgeInsets.symmetric(horizontal: 8.w);
  static EdgeInsets ph16 = EdgeInsets.symmetric(horizontal: 16.w);
}