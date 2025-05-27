import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../common/constant/app_constants.dart';
import '../../../../common/extension/core_extension.dart';
import '../../../../common/extension/number_extension.dart';
import '../../../../common/util/date_picker/adaptive.dart';
import '../../../../common/util/date_picker/date_time_picker_utility.dart';
import '../../../../common/util/text_input_formatter_util.dart';
import '../../../../common/widgets/core_widgets.dart';
import '../../../../common/widgets/text_input/number_text_input.dart';
import '../../../../common/widgets/text_input/primary_text_input.dart';
import '../bloc/add_water_bloc.dart';

class WaterFormSection extends StatefulWidget {
  const WaterFormSection({super.key});

  @override
  State<WaterFormSection> createState() => _FormSectionState();
}

class _FormSectionState extends State<WaterFormSection> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _waterController = TextEditingController();
  final TextEditingController _dayController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  final DateTimePickerUtility _dateTimePickerUtility = AdaptiveDateTimePicker();

  @override
  void dispose() {
    _formKey.currentState?.dispose();
    _waterController.dispose();
    _dayController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return BlocListener<AddWaterBloc, AddWaterState>(
      listener: _handleStateListener,
      child: Padding(
        padding: AppPadding.ph16 + AppPadding.pt24,
        child: Column(
          children: [
            Expanded(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    BlocBuilder<AddWaterBloc, AddWaterState>(
                      buildWhen: (_, state) {
                        return state is UpdateUnitSymbolState;
                      },
                      builder: (context, state) {
                        final String unit = context.read<AddWaterBloc>().unitSymbol;

                        return NumberTextInput(
                          hintText: '150',
                          labelText:
                              '${context.localization.water} ${context.localization.consumed}',
                          controller: _waterController,
                          fillColor: AppColors.white,
                          isFilled: true,
                          onFieldSubmitted: _handleWaterChanged,
                          autoValidateMode: AutovalidateMode.onUserInteraction,
                          suffix: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                unit,
                                style: AppTextStyle.textBase.addAll([
                                  AppTextStyle.textBase.leading6
                                ]).copyWith(color: AppColors.gray900),
                              ),
                            ],
                          ),
                          inputFormatters: [
                            NumberInputFormatter.singleCommaOrDecimalFormatter,
                          ],
                          validator: (value) {
                            final double? water = double.tryParse(value ?? '');
                            if (water == null || water <= 0) {
                              return context.localization.pleaseEnterValidWater;
                            }
                            return null;
                          },
                        );
                      },
                    ),
                    16.verticalSpace,
                    PrimaryTextInput(
                      hintText: '',
                      labelText: context.localization.day,
                      controller: _dayController,
                      fillColor: AppColors.white,
                      isFilled: true,
                      readOnly: true,
                      onTap: () => _onTapDay(context: context),
                    ),
                    16.verticalSpace,
                    PrimaryTextInput(
                      hintText: '',
                      labelText: context.localization.time,
                      controller: _timeController,
                      fillColor: AppColors.white,
                      isFilled: true,
                      readOnly: true,
                      onTap: () => _onTapTime(context: context),
                    ),
                  ],
                ),
              ),
            ),
            BlocBuilder<AddWaterBloc, AddWaterState>(
              buildWhen: (_, state) {
                return state is UpdateActionButtonState;
              },
              builder: (context, state) {
                final bool isNew = context.read<AddWaterBloc>().isNew;
                return Row(
                  children: [
                    Expanded(
                      child: SecondaryButton(
                        text: context.localization.cancel,
                        onTap: () => _onTapCancel(context: context),
                      ),
                    ),
                    16.horizontalSpace,
                    Expanded(
                      child: PrimaryButton(
                        text: isNew
                            ? context.localization.save
                            : context.localization.update,
                        onTap: () {
                          if (_formKey.currentState?.validate() == true) {
                            context.read<AddWaterBloc>().add(const SaveEvent());
                          }
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onTapDay({required BuildContext context}) async {
    final date =
        await _dateTimePickerUtility.showDatePickerDialog(context: context);
    if (date != null && context.mounted) {
      context.read<AddWaterBloc>().add(UpdateDayEvent(date: date));
    }
  }

  Future<void> _onTapTime({required BuildContext context}) async {
    final time =
        await _dateTimePickerUtility.showTimePickerDialog(context: context);
    if (time != null && context.mounted) {
      context.read<AddWaterBloc>().add(UpdateTimeEvent(time: time));
    }
  }

  void _handleStateListener(BuildContext context, AddWaterState state) {
    if (state is UpdateWaterState) {
      _waterController.text = context.read<AddWaterBloc>().water.format();
    } else if (state is UpdateDayState) {
      _dayController.text = context.read<AddWaterBloc>().day;
    } else if (state is UpdateTimeState) {
      _timeController.text = context.read<AddWaterBloc>().time;
    }
  }

  void _handleWaterChanged(String value) {
    context.read<AddWaterBloc>().add(UpdateWaterEvent(water: value));
  }

  void _onTapCancel({required BuildContext context}) {
    Navigator.pop(context);
  }
}
