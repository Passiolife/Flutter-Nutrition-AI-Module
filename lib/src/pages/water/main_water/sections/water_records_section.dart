import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../../common/dialogs/delete_confirmation_dialog.dart';
import '../../../../common/extension/core_extension.dart';
import '../../../../common/extension/date_time_extension.dart';
import '../../../../common/extension/number_extension.dart';
import '../../../../common/models/user_profile/user_profile_model.dart';
import '../../../../common/models/water_record/water_record.dart';
import '../../../../common/router/routes.dart';
import '../../../../common/util/date_time_utility.dart';
import '../../../../common/util/snackbar_extension.dart';
import '../../../../common/widgets/custom_expansion_tile_widget.dart';
import '../bloc/water_bloc.dart';
import '../widgets/water_row_widget.dart';

class WaterRecordsSection extends StatelessWidget {
  const WaterRecordsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WaterBloc, WaterState>(
      buildWhen: (_, state) {
        return state is InitialState || state is UpdateRecordsState;
      },
      builder: (context, state) {
        List<WaterRecord> list = [];
        MeasurementSystem? unit;
        String unitSymbol = '';
        DateTime startDate = DateTime.now();
        DateTime endDate = DateTime.now();
        bool isMonthRange = false;

        if (state is UpdateRecordsState) {
          list = state.records;
          unitSymbol = state.unitSymbol;
          unit = state.unit;
          startDate = state.startDate;
          endDate = state.endDate;
          isMonthRange = state.isMonthRange;
        }

        return SlidableAutoCloseBehavior(
          child: CustomExpansionTileWidget(
            title: startDate.rangeString(
              isMonthRange: isMonthRange,
              endDateTime: endDate,
            ),
            children: _getWaterRowWidget(
              context: context,
              list: list,
              unitSymbol: unitSymbol,
              unit: unit,
            ),
          ),
        );
      },
    );
  }

  List<WaterRowWidget> _getWaterRowWidget({
    required BuildContext context,
    required List<WaterRecord> list,
    required String unitSymbol,
    MeasurementSystem? unit,
  }) {
    return list.map((e) {
      final DateTime dateTime =
          DateTime.fromMillisecondsSinceEpoch(e.createdAt);
      final String date =
          dateTime.formatToStringNew(DateFormatStrings.weekdayMonthDay);
      final String time = dateTime
          .formatToStringNew(TimeFormatString.hourMinute12HourLeadingZero);
      return WaterRowWidget(
        value: e.getWater(unit: unit).format(),
        unit: unitSymbol,
        date: date,
        time: time,
        onDelete: (needConfirmation) => _confirmDeleteWaterRecord(
          context: context,
          record: e,
          needConfirmation: needConfirmation,
        ),
        onEdit: () => _edit(context: context, record: e),
      );
    }).toList();
  }

  void _confirmDeleteWaterRecord({
    required BuildContext context,
    required WaterRecord record,
    required bool needConfirmation,
  }) {
    if (!needConfirmation) {
      _delete(context: context, record: record);
      return;
    }
    DeleteConfirmationDialog.show(
        context: context,
        onConfirm: () {
          _delete(context: context, record: record);
        });
  }

  void _delete({
    required BuildContext context,
    required WaterRecord record,
  }) {
    context.read<WaterBloc>().add(DeleteWaterEvent(record: record));
  }

  Future<void> _edit({
    required BuildContext context,
    required WaterRecord record,
  }) async {
    final bool? result = await Navigator.pushNamed(context, Routes.addWaterPage,
        arguments: record);
    if (result == true && context.mounted) {
      context.showSnackbar(text: context.localization.waterRecordUpdateMessage);
      context.read<WaterBloc>().add(const FetchRecordsEvent());
    }
  }
}
