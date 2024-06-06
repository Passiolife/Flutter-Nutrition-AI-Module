import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/constant/app_constants.dart';
import '../../../../common/models/user_profile/user_profile_model.dart';
import '../../../../common/models/weight_record/weight_record.dart';
import '../../../../common/util/context_extension.dart';
import '../../../../common/util/double_extensions.dart';
import '../../../../common/util/snackbar_extension.dart';
import '../../../../common/util/user_session.dart';
import '../../widgets/measurement_app_bar.dart';
import 'bloc/add_weight_bloc.dart';
import 'widgets/widgets.dart';

class AddWeightPage extends StatefulWidget {
  const AddWeightPage({this.record, super.key});

  final WeightRecord? record;

  static Future navigate(
      {required BuildContext context, WeightRecord? record}) async {
    return await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddWeightPage(record: record)),
    );
  }

  @override
  State<AddWeightPage> createState() => _AddWeightPageState();
}

class _AddWeightPageState extends State<AddWeightPage>
    implements AddUnitFormListener {
  late String _consumedWater;
  late DateTime _createdAt;

  final _bloc = AddWeightBloc();

  bool get isNew => widget.record == null;

  int? get id => widget.record?.id;

  final _profileModel = UserSession.instance.userProfile;

  @override
  void initState() {
    _consumedWater =
        widget.record?.getWeight(unit: _profileModel?.weightUnit).format() ??
            '';
    _createdAt = widget.record != null
        ? DateTime.fromMillisecondsSinceEpoch(widget.record!.createdAt)
        : DateTime.now();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddWeightBloc, AddWeightState>(
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
                unitTitle: context.localization?.weight ?? '',
                hintText: '150.0',
                unit: _profileModel?.weightUnit == MeasurementSystem.imperial
                    ? context.localization?.lbs
                    : context.localization?.kg,
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
    if (_consumedWater.isNotEmpty && (double.parse(_consumedWater)) > 0) {
      _bloc.add(SaveWaterEvent(
        weightMeasurement: _consumedWater,
        unit: _profileModel?.weightUnit,
        createdAt: _createdAt,
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
