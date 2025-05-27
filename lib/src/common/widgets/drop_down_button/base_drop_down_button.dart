import 'package:flutter/material.dart';

class BaseDropDownButton<T> extends StatelessWidget {
  const BaseDropDownButton({
    required this.options,
    this.selected,
    this.borderRadius,
    this.onChanged,
    this.underline,
    this.showUnderline = false,
    this.dropdownColor,
    this.isDense = true,
    super.key,
  });

  final List<DropdownMenuItem<T>> options;
  final T? selected;
  final ValueChanged<T?>? onChanged;
  final BorderRadius? borderRadius;
  final bool isExpanded = false;
  final bool showUnderline;
  final Widget? underline;
  final Color? dropdownColor;
  final bool isDense;

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      value: selected,
      items: options,
      borderRadius: borderRadius,
      onChanged: onChanged,
      underline: showUnderline ? underline : const SizedBox.shrink(),
      dropdownColor: dropdownColor,
      isDense: isDense,
    );
  }
}
