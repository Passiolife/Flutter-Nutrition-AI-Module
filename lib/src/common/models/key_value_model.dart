import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class KeyValueModel<T> extends Equatable {
  final Widget? icon;
  final String text;
  final T value;

  const KeyValueModel({
    this.icon,
    required this.text,
    required this.value,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [icon, text, value];
}
