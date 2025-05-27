import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/router/routes.dart';
import '../bloc_/home_bloc.dart';
import '../widgetss/water_weight_widgets.dart';

class WeightWaterSection extends StatelessWidget {
  const WeightWaterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      buildWhen: (_, state) {
        return state is UpdateWaterWeightState;
      },
      builder: (context, state) {
        String? waterUnit;
        double consumedWater = 0;
        double remainingWater = 0;
        String? weightUnit;
        double measuredWeight = 0;
        double remainingWeight = 0;

        if (state is UpdateWaterWeightState) {
          waterUnit = state.waterUnit;
          consumedWater = state.consumedWater;
          remainingWater = state.remainingWater;
          weightUnit = state.weightUnit;
          measuredWeight = state.measuredWeight;
          remainingWeight = state.remainingWeight;
        }

        return WaterWeightWidget(
          waterUnit: waterUnit,
          consumedWater: consumedWater,
          remainingWater: remainingWater,
          onTapWater: () => _onTapWater(context),
          weightUnit: weightUnit,
          measuredWeight: measuredWeight,
          remainingWeight: remainingWeight,
          onTapWeight: () => _onTapWeight(context),
        );
      },
    );
  }

  Future<void> _onTapWater(BuildContext context) async {
    await Navigator.pushNamed(context, Routes.waterPage);
    if(!context.mounted) return;
    context.read<HomeBloc>().add(const UpdateWaterEvent());
  }

  Future<void> _onTapWeight(BuildContext context) async {
    await Navigator.pushNamed(context, Routes.weightPage);
    if(!context.mounted) return;
    context.read<HomeBloc>().add(const UpdateWeightEvent());
  }
}
