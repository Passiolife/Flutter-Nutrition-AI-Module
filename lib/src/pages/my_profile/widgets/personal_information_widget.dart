import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/constant/app_constants.dart';
import '../../../common/dialogs/ok_button_with_keyboard.dart';
import '../../../common/models/user_profile/user_profile_model.dart';
import '../../../common/util/context_extension.dart';
import '../../../common/util/double_extensions.dart';
import '../../../common/util/string_extensions.dart';
import '../../../common/widgets/app_drop_down_menu.dart';
import '../../../common/widgets/app_text_field.dart';
import '../dialogs/height_dialog.dart';
import 'labeled_widget_row.dart';

abstract class PersonalInformationListener {
  void onNameChanged(String name);

  void onAgeChanged(int? age);

  void onGenderChanged(GenderSelection gender);

  void onHeightChanged(int unit, int subunit);

  void onWeightChanged(double? weight);
}

class PersonalInformationWidget extends StatefulWidget {
  const PersonalInformationWidget({
    this.name,
    this.age,
    this.gender,
    this.height,
    this.heightDescription,
    this.heightUnit = MeasurementSystem.imperial,
    this.weight,
    this.weightUnit = MeasurementSystem.imperial,
    this.listener,
    super.key,
  });

  final String? name;
  final int? age;
  final GenderSelection? gender;

  // Height related
  final MeasurementSystem? heightUnit;
  final ({int unit, int subunit})? height;
  final String? heightDescription;

  // Weight related
  final MeasurementSystem? weightUnit;
  final double? weight;

  final PersonalInformationListener? listener;

  @override
  State<PersonalInformationWidget> createState() =>
      _PersonalInformationWidgetState();
}

class _PersonalInformationWidgetState extends State<PersonalInformationWidget> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final FocusNode _ageFocusNode = FocusNode();
  final FocusNode _weightFocusNode = FocusNode();

  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  List<String> get _genderEntries =>
      GenderSelection.values.map((e) => e.name.toUpperCaseWord).toList();

  OkButtonWithKeyboard? okButtonWithKeyboard;

  @override
  void initState() {
    // Set Initial Value.
    _nameController.text = widget.name ?? '';
    _ageController.text = widget.age?.toString() ?? '';
    _heightController.text = widget.heightDescription ?? '';
    _weightController.text = widget.weight?.format() ?? '';

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      // Focus Node
      OkButtonWithKeyboard.setup(
        context: context,
        focusNode: _ageFocusNode,
      );

      OkButtonWithKeyboard.setup(
        context: context,
        focusNode: _weightFocusNode,
        onTap: () {
          _weightController.text = double.tryParse(_weightController.text)?.format() ?? '';
        },
      );
    });

    // Set Listeners
    _nameController.addListener(() {
      widget.listener?.onNameChanged(_nameController.text);
    });
    _ageController.addListener(() {
      widget.listener?.onAgeChanged(int.tryParse(_ageController.text));
    });
    _weightController.addListener(() {
      widget.listener?.onWeightChanged(double.tryParse(_weightController.text));
    });

    super.initState();
  }

  @override
  void dispose() {
    _ageFocusNode.dispose();
    _weightFocusNode.dispose();
    _nameController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppShadows.base,
      padding: EdgeInsets.all(16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.localization?.personalInformation ?? '',
            style: AppTextStyle.textBase.addAll(
                [AppTextStyle.textBase.leading6, AppTextStyle.semiBold]),
          ),
          16.verticalSpace,
          LabeledWidgetRow(
            title: context.localization?.name,
            child: AppTextField(
              controller: _nameController,
              style: AppTextStyle.textBase
                  .addAll([AppTextStyle.textBase.leading6]),
            ),
          ),
          16.verticalSpace,
          LabeledWidgetRow(
            title: context.localization?.age,
            child: AppTextField(
              controller: _ageController,
              focusNode: _ageFocusNode,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(2),
              ],
              keyboardType: TextInputType.number,
              style: AppTextStyle.textBase
                  .addAll([AppTextStyle.textBase.leading6]),
            ),
          ),
          16.verticalSpace,
          LabeledWidgetRow(
            title: context.localization?.gender,
            child: AppDropDownMenu<String>(
              initialSelection: widget.gender?.name.toUpperCaseWord,
              dropdownMenuEntries: _genderEntries
                  .map((e) => DropdownMenuEntry(
                      value: e.toUpperCaseWord, label: e.toUpperCaseWord))
                  .toList(),
              onSelected: (value) {
                if (value != null) {
                  widget.listener?.onGenderChanged(GenderSelection.values
                      .firstWhere((element) =>
                          element.name.toLowerCase() == value.toLowerCase()));
                }
              },
            ),
          ),
          16.verticalSpace,
          LabeledWidgetRow(
            title: context.localization?.height,
            child: AppTextField(
              controller: _heightController,
              readOnly: true,
              onTap: () {
                HeightDialog.show(
                  context: context,
                  measurementSystem: widget.heightUnit,
                  initialUnit: widget.height?.unit ?? 0,
                  initialSubunit: widget.height?.subunit ?? 0,
                  onSaveHeight: widget.listener?.onHeightChanged,
                );
              },
              style: AppTextStyle.textBase
                  .addAll([AppTextStyle.textBase.leading6]),
            ),
          ),
          16.verticalSpace,
          LabeledWidgetRow(
            title: context.localization?.weight,
            child: AppTextField(
              controller: _weightController,
              focusNode: _weightFocusNode,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*')),
              ],
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              suffixIcon: Padding(
                padding: EdgeInsets.only(right: AppDimens.w8),
                child: Text(
                  widget.weightUnit == MeasurementSystem.imperial
                      ? WeightUnits.lbs.name
                      : WeightUnits.kg.name,
                  style: AppTextStyle.textBase
                      .addAll([AppTextStyle.textBase.leading6]).copyWith(
                          color: AppColors.gray900),
                ),
              ),
              suffixIconConstraints: BoxConstraints(
                  minHeight: AppTextStyle.textBase.fontSize ?? 14),
              style: AppTextStyle.textBase
                  .addAll([AppTextStyle.textBase.leading6]),
            ),
          ),
        ],
      ),
    );
  }
}
