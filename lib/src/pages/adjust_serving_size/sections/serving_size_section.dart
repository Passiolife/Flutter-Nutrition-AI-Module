import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/widgets/passio/serving_size_widget.dart';
import '../bloc/adjust_serving_size_bloc.dart';

class ServingSizeSection extends StatelessWidget {
  const ServingSizeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdjustServingSizeBloc, AdjustServingSizeState>(
      buildWhen: (_, state) => state is RefreshServingSizeState,
      builder: (context, state) {
        double quantity = 1;
        String unit = '';
        List<String> units = [];

        if(state is RefreshServingSizeState) {
          quantity = state.quantity;
          unit = state.unit;
          units = state.units;
        }

        return ServingSizeWidget(
          initialQuantity: quantity,
          initialUnit: unit,
          units: units,
          onServingSizeChanged: (servingSize) {
            context.read<AdjustServingSizeBloc>().add(
              UpdateServingSizeEvent(
                quantity: servingSize.quantity,
                unit: servingSize.unit,
              ),
            );
          },
        );
      },
    );
  }
}
