import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/widgets/date_time/range_date_time_widget.dart';
import '../bloc/water_bloc.dart';

class WaterDateRangeSection extends StatelessWidget {
  const WaterDateRangeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WaterBloc, WaterState>(
      buildWhen: (previous, state) {
        return state is UpdateTabState || state is UpdatePageState;
      },
      builder: (context, state) {
        int selectedTab = context.read<WaterBloc>().selectedTab;
        return RangeDateTimeWidget(
          key: ValueKey(selectedTab),
          period: selectedTab == 1 ? DatesPeriod.month : DatesPeriod.week,
          onRangeChange: (start, end) =>
              _onRangeChange(context: context, startDate: start, endDate: end),
        );
      },
    );
  }

  void _onRangeChange({
    required BuildContext context,
    required DateTime startDate,
    required DateTime endDate,
  }) {
    context
        .read<WaterBloc>()
        .add(UpdateDateRangeEvent(startDate: startDate, endDate: endDate));
  }
}
