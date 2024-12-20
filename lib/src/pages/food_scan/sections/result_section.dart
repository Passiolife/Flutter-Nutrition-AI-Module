import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/constant/app_colors.dart';
import '../../../common/util/context_extension.dart';
import '../../../common/util/show_widget_util.dart';
import '../../../common/widgets/bottom_sheet/base_bottom_sheet.dart';
import '../bloc/food_scan_bloc.dart';
import '../widgets/barcode_not_recognized_widget.dart';
import '../widgets/scanning_widget.dart';

class ResultSection extends StatefulWidget {
  const ResultSection({super.key});

  @override
  State<ResultSection> createState() => _ResultSectionState();
}

class _ResultSectionState extends State<ResultSection> {
  late final double _minHeight = context.height * 0.32;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FoodScanBloc, FoodScanState>(
      // listenWhen: (_, state) {
      //   return state is BarcodeNotRecognizedEvent;
      // },
      // listener: (context, state) => _handleStateChanges(context, state),
      buildWhen: (_, state) {
        return state is BarcodeNotRecognizedState;
      },
      builder: (context, state) {
        // return SizedBox.shrink();

        if(state is BarcodeNotRecognizedState) {
          return SizedBox.shrink();
        }
        return Align(
          alignment: Alignment.bottomCenter,
          child: BaseBottomSheet(
            height: _minHeight,
            child: ScanningWidget(),
          ),
        );
      },
    );
  }
}
