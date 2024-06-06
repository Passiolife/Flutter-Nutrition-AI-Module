import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/constant/app_constants.dart';
import '../../../common/util/context_extension.dart';
import '../../../common/util/date_picker.dart';
import '../../../common/util/date_time_utility.dart';
import '../../../common/util/time_picker.dart';
import '../../../common/widgets/action_buttons_widget.dart';
import '../../../common/widgets/app_text_field.dart';

abstract interface class AddUnitFormListener {
  void onUnitValueChanged(String newValue);

  void onDateTimeChanged(DateTime newDateTime);

  void onCancelTapped();

  void onSaveTapped();
}

class AddUnitFormWidget extends StatefulWidget {
  AddUnitFormWidget({
    required this.value,
    this.createdAt,
    this.unit,
    this.unitTitle,
    this.hintText,
    this.listener,
  }) : super(key: ValueKey('$value-$createdAt'));

  final String value;
  final DateTime? createdAt;
  final String? unitTitle;
  final String? hintText;
  final String? unit;
  final AddUnitFormListener? listener;

  @override
  State<AddUnitFormWidget> createState() => _AddWaterFormWidgetState();
}

class _AddWaterFormWidgetState extends State<AddUnitFormWidget> {
  final _formKey = GlobalKey<FormState>();

  final _unitValueController = TextEditingController();
  final _dayController = TextEditingController();
  final _timeController = TextEditingController();

  late DateTime _selectedDateTime;

  @override
  void initState() {
    _selectedDateTime = widget.createdAt ?? DateTime.now();

    _unitValueController.text = widget.value;
    _dayController.text = _selectedDateTime.formatToString(format13);
    _timeController.text = _selectedDateTime.formatToString(format3);

    //
    _unitValueController.addListener(() {
      widget.listener?.onUnitValueChanged(_unitValueController.text);
    });
    super.initState();
  }

  @override
  void dispose() {
    _unitValueController.dispose();
    _dayController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppDimens.w16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Weight View
              _buildFormField(
                context: context,
                controller: _unitValueController,
                labelText: widget.unitTitle,
                inputType: const TextInputType.numberWithOptions(decimal: true),
                inputAction: TextInputAction.done,
                hintText: widget.hintText,
                hintStyle: AppTextStyle.textBase
                    .addAll([AppTextStyle.textBase.leading6]).copyWith(
                        color: AppColors.gray300),
                suffixIcon: Padding(
                  padding: EdgeInsets.only(right: AppDimens.w8),
                  child: Text(
                    widget.unit ?? '',
                    style: AppTextStyle.textBase
                        .addAll([AppTextStyle.textBase.leading6]).copyWith(
                            color: AppColors.gray900),
                  ),
                ),
                suffixIconConstraints: BoxConstraints(
                    minHeight: AppTextStyle.textBase.fontSize ?? 14),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*')),
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,1}')),
                ],
              ),
              _buildFormField(
                context: context,
                labelText: context.localization?.day,
                controller: _dayController,
                onTap: () {
                  DatePicker.showAdaptive(
                    context: context,
                    selectedDate: widget.createdAt,
                    onDateTimeChanged: (dateTime) {
                      _selectedDateTime = _selectedDateTime.copyWith(
                        year: dateTime.year,
                        month: dateTime.month,
                        day: dateTime.day,
                      );
                      _dayController.text =
                          _selectedDateTime.formatToString(format13);
                      widget.listener?.onDateTimeChanged(_selectedDateTime);
                    },
                  );
                },
              ),
              _buildFormField(
                context: context,
                labelText: context.localization?.time,
                controller: _timeController,
                onTap: () {
                  TimePicker.showAdaptive(
                    context: context,
                    selectedTime: widget.createdAt,
                    onDateTimeChanged: (dateTime) {
                      _selectedDateTime = _selectedDateTime.copyWith(
                        hour: dateTime.hour,
                        minute: dateTime.minute,
                      );
                      _timeController.text =
                          _selectedDateTime.formatToString(format3);
                      widget.listener?.onDateTimeChanged(_selectedDateTime);
                    },
                  );
                },
              ),
              const Spacer(),
              ActionButtonsWidget(
                onTapCancel: widget.listener?.onCancelTapped,
                onTapSave: widget.listener?.onSaveTapped,
              ),
              40.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormField({
    required BuildContext context,
    String? labelText,
    TextInputType? inputType,
    TextInputAction? inputAction,
    VoidCallback? onTap,
    String? hintText,
    TextStyle? hintStyle,
    Widget? suffixIcon,
    BoxConstraints? suffixIconConstraints,
    FormFieldValidator? validator,
    TextEditingController? controller,
    List<TextInputFormatter>? inputFormatters,
    int? maxLength,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        16.verticalSpace,
        Text(
          labelText ?? '',
          style: AppTextStyle.textSm.addAll([
            AppTextStyle.textSm.leading4,
            AppTextStyle.medium
          ]).copyWith(color: AppColors.gray900),
        ),
        8.verticalSpace,
        AppTextField(
          keyboardType: inputType,
          onTap: onTap,
          style: AppTextStyle.textBase.addAll([AppTextStyle.textBase.leading6]),
          hintText: hintText,
          hintStyle: hintStyle,
          readOnly: onTap != null,
          suffixIcon: suffixIcon,
          suffixIconConstraints: suffixIconConstraints,
          inputAction: inputAction,
          validator: validator,
          controller: controller,
          inputFormatters: inputFormatters,
          maxLength: maxLength,
        ),
      ],
    );
  }
}
