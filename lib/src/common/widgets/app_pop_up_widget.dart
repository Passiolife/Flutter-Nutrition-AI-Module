import 'package:flutter/material.dart';

import '../constant/app_constants.dart';

class AppPopupWidget<T> extends StatelessWidget {
  const AppPopupWidget({
    required this.items,
    required this.itemBuilder,
    this.icon,
    this.initialValue,
    this.position = PopupMenuPosition.under,
    this.padding = EdgeInsets.zero,
    this.onSelected,
    this.constraints,
    super.key,
  });

  final T? initialValue;
  final List<T> items;
  final PopupMenuPosition position;
  final EdgeInsets padding;
  final Widget? icon;
  final PopupMenuItemSelected<T>? onSelected;
  final BoxConstraints? constraints;
  final Widget? Function(T item) itemBuilder;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        highlightColor: AppColors.blue50,
        popupMenuTheme: PopupMenuThemeData(
          color: Colors.white,
          surfaceTintColor: AppColors.white,
          textStyle: AppTextStyle.textSm.addAll([AppTextStyle.textSm.leading5]),
          shape: const RoundedRectangleBorder(
            side: BorderSide(color: AppColors.gray300),
          ),
          elevation: 10,
          shadowColor: AppColors.black.withOpacity(0.16),
        ),
      ),
      child: PopupMenuButton<T>(
        icon: icon,
        position: PopupMenuPosition.under,
        padding: padding,
        initialValue: initialValue,
        onSelected: onSelected,
        constraints: constraints,
        itemBuilder: (context) {
          return <PopupMenuEntry<T>>[
            ...(items
                .asMap()
                .map(
                  (index, element) => MapEntry(
                    index,
                    PopupMenuItem<T>(
                      value: items.elementAt(index),
                      child: itemBuilder.call(element),
                    ),
                  ),
                )
                .values
                .toList()),
          ];
        },
      ),
    );
  }
}
