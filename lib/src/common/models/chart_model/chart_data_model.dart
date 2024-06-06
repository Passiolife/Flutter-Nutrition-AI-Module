import 'package:flutter/material.dart';

class ChartDataModel {
  ChartDataModel({this.x = '', required this.y, required this.color});

  final String x;
  final double y;
  final Color color;
}
