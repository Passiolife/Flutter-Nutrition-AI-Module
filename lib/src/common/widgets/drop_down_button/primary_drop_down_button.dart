import 'package:flutter/material.dart';

import '../../constant/app_constants.dart';
import '../../extension/core_extension.dart';
import '../../models/key_value_model.dart';
import 'base_drop_down_button.dart';

class PrimaryDropDownButton<T> extends StatelessWidget {
  const PrimaryDropDownButton({
    required this.options,
    this.selected,
    this.onChanged,
    super.key,
  });

  final List<KeyValueModel<T>> options;
  final KeyValueModel<T>? selected;
  final ValueChanged<KeyValueModel<T>?>? onChanged;

  @override
  Widget build(BuildContext context) {
    return BaseDropDownButton<T>(
      options: options
          .map(
            (e) => DropdownMenuItem(
              value: e.value,
              child: Text(
                e.text,
                style: AppTextStyle.textSm
                    .addAll([AppTextStyle.textSm.leading5]).copyWith(
                        color: AppColors.gray900),
              ),
            ),
          )
          .toList(),
      selected: selected?.value,
      borderRadius: AppBorderCircular.ba8,
      onChanged: (value) {
        KeyValueModel<T>? selectedValue = options.cast<KeyValueModel<T>?>().firstWhere(
          (element) => element?.value == value,
          orElse: () => null,
        );
        onChanged?.call(selectedValue);
      },
      showUnderline: false,
      dropdownColor: context.theme.scaffoldBackgroundColor,
    );
  }
}
