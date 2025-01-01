import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppPadding {
  AppPadding._();

  /// Padding All
  static EdgeInsets pa8 = EdgeInsets.all(8.r);
  static EdgeInsets pa10 = EdgeInsets.all(10.r);
  static EdgeInsets pa16 = EdgeInsets.all(16.r);

  /// Padding Left
  static EdgeInsets pl8 = EdgeInsets.only(left: 8.w);

  /// Padding Right
  static EdgeInsets pr16 = EdgeInsets.only(right: 16.w);

  /// Padding Top
  static EdgeInsets pt4 = EdgeInsets.only(top: 4.h);
  static EdgeInsets pt8 = EdgeInsets.only(top: 8.h);
  static EdgeInsets pt12 = EdgeInsets.only(top: 12.h);
  static EdgeInsets pt16 = EdgeInsets.only(top: 16.h);

  /// Padding Bottom
  static EdgeInsets pb4 = EdgeInsets.only(bottom: 4.h);
  static EdgeInsets pb8 = EdgeInsets.only(bottom: 8.h);
  static EdgeInsets pb16 = EdgeInsets.only(bottom: 16.h);
  static EdgeInsets pb32 = EdgeInsets.only(bottom: 32.h);
  static EdgeInsets pb64 = EdgeInsets.only(bottom: 64.h);

  /// Vertical Padding
  static EdgeInsets pv2 = EdgeInsets.symmetric(vertical: 2.h);
  static EdgeInsets pv4 = EdgeInsets.symmetric(vertical: 4.h);
  static EdgeInsets pv8 = EdgeInsets.symmetric(vertical: 8.h);
  static EdgeInsets pv10 = EdgeInsets.symmetric(vertical: 10.h);
  static EdgeInsets pv12 = EdgeInsets.symmetric(vertical: 12.h);
  static EdgeInsets pv16 = EdgeInsets.symmetric(vertical: 16.h);

  /// Horizontal Padding
  static EdgeInsets ph4 = EdgeInsets.symmetric(horizontal: 4.w);
  static EdgeInsets ph8 = EdgeInsets.symmetric(horizontal: 8.w);
  static EdgeInsets ph12 = EdgeInsets.symmetric(horizontal: 12.w);
  static EdgeInsets ph16 = EdgeInsets.symmetric(horizontal: 16.w);
  static EdgeInsets ph24 = EdgeInsets.symmetric(horizontal: 24.w);
  static EdgeInsets ph40 = EdgeInsets.symmetric(horizontal: 40.w);
}