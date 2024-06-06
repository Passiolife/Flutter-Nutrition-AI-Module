import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/constant/app_constants.dart';
import '../../../../common/models/user_profile/user_profile_model.dart';
import '../../../../common/models/water_record/water_record.dart';
import '../../../../common/util/context_extension.dart';
import '../../../../common/util/double_extensions.dart';
import '../../../../common/util/keyboard_extension.dart';
import '../../../../common/util/snackbar_extension.dart';
import '../../../../common/util/user_session.dart';
import '../../widgets/measurement_app_bar.dart';
import 'bloc/add_water_bloc.dart';
import 'widgets/widgets.dart';

class AddWaterPage extends StatefulWidget {
  const AddWaterPage({this.record, super.key});

  final WaterRecord? record;

  static Future navigate(
      {required BuildContext context, WaterRecord? record}) async {
    return await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddWaterPage(record: record)),
    );
  }

  @override
  State<AddWaterPage> createState() => _AddWaterPageState();
}

class _AddWaterPageState extends State<AddWaterPage>
    implements AddUnitFormListener {
  late String _consumedWater;
  late DateTime _createdAt;

  final _bloc = AddWaterBloc();

  bool get isNew => widget.record == null;

  int? get id => widget.record?.id;

  final _profileModel = UserSession.instance.userProfile;

  @override
  void initState() {
    _consumedWater = widget.record
            ?.getWater(
                unit: _profileModel?.weightUnit ?? MeasurementSystem.imperial)
            .format() ??
        '';
    _createdAt = widget.record != null
        ? DateTime.fromMillisecondsSinceEpoch(widget.record!.createdAt)
        : DateTime.now();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddWaterBloc, AddWaterState>(
      bloc: _bloc,
      listener: (context, state) {
        if (state is SaveSuccessState) {
          Navigator.pop(context, true);
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.gray50,
          body: Column(
            children: [
              MeasurementAppBar(
                title: isNew
                    ? context.localization?.newEntry
                    : context.localization?.editEntry,
                visibleAdd: false,
              ),
              SizedBox(height: AppDimens.h8),
              AddUnitFormWidget(
                value: _consumedWater,
                createdAt: _createdAt,
                unitTitle:
                    '${context.localization?.water ?? ''} ${context.localization?.consumed ?? ''}',
                hintText: '150',
                unit: _profileModel?.weightUnit == MeasurementSystem.imperial
                    ? context.localization?.oz
                    : context.localization?.ml,
                listener: this,
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void onCancelTapped() {
    Navigator.pop(context);
  }

  @override
  void onSaveTapped() {
    context.hideKeyboard();
    if (_consumedWater.isNotEmpty &&
        (double.tryParse(_consumedWater) ?? 0) > 0) {
      _bloc.add(SaveWaterEvent(
        consumedWater: _consumedWater,
        createdAt: _createdAt,
        unit: _profileModel?.weightUnit ?? MeasurementSystem.imperial,
        isNew: isNew,
        id: id,
      ));
    } else {
      context.showSnackbar(text: context.localization?.waterValidationMessage);
    }
  }

  @override
  void onUnitValueChanged(String newValue) {
    _consumedWater = newValue;
  }

  @override
  void onDateTimeChanged(DateTime newDateTime) {
    _createdAt = newDateTime;
  }
}
