import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/food_scan_bloc.dart';
import '../widgets/scanning_animation_widget_new.dart';

class ScanningAnimationSection extends StatelessWidget {
  const ScanningAnimationSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FoodScanBloc, FoodScanState>(
      buildWhen: (_, state) =>
          state is FoodScanInitial || state is BarcodeNotRecognizedState || state is ScanningState || state is AddedToDiaryVisibilityState,
      builder: (context, state) {
        return state is BarcodeNotRecognizedState || state is AddedToDiaryVisibilityState
            ? const SizedBox.shrink()
            : const ScanningAnimationWidget();
      },
    );
  }
}
