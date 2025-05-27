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
  List<Object?> get props => [icon, text, value];

  KeyValueModel<T> copyWith({
    Widget? icon,
    String? text,
    T? value,
  }) {
    return KeyValueModel(
      icon: icon ?? this.icon,
      text: text ?? this.text,
      value: value ?? this.value,
    );
  }
}
