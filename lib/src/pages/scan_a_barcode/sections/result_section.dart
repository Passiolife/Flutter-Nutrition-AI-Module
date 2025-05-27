import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrition_ai/nutrition_ai.dart';

import '../../../common/extension/context_extension.dart';
import '../../../common/router/routes.dart';
import '../../../common/widgets/bottom_sheet/base_bottom_sheet.dart';
import '../../edit_food/ui/edit_food_page.dart';
import '../bloc/food_scan_bloc.dart';
import '../widgets/result_widget.dart';
import '../widgets/scanning_widget.dart';

class ResultSection extends StatefulWidget {
  const ResultSection({super.key});

  @override
  State<ResultSection> createState() => _ResultSectionState();
}

class _ResultSectionState extends State<ResultSection> {
  late final double _minHeight = context.height * 0.25;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FoodScanBloc, FoodScanState>(
      buildWhen: (_, state) {
        return state is FoodScanInitial ||
            state is BarcodeNotRecognizedStateNew ||
            state is ScanningState ||
            state is ScanResultState ||
            state is ScanLoadingState ||
            state is AddedToDiaryVisibilityState;
      },
      builder: (context, state) {
        String? iconId;
        String? title;
        String? subtitle;
        if (state is BarcodeNotRecognizedStateNew ||
            state is AddedToDiaryVisibilityState) {
          return const SizedBox.shrink();
        } else if (state is ScanResultState) {
          iconId = state.iconId;
          title = state.title;
          subtitle = state.subtitle;
        }
        return Align(
          alignment: Alignment.bottomCenter,
          child: BaseBottomSheet(
            height: _minHeight,
            child: state is ScanResultState
                ? ResultWidget(
                    iconId: iconId ?? '',
                    title: title,
                    subtitle: subtitle,
                    onEdit: () => _onEdit(context: context),
                    onLog: () => _onLog(context: context),
                  )
                : ScanningWidget(
                    onTap: _openNutritionFacts,
                  ),
          ),
        );
      },
    );
  }

  void _onEdit({required BuildContext context}) {
    final foodRecord = context.read<FoodScanBloc>().foodRecord;
    final foodItem = context.read<FoodScanBloc>().foodItem;
    EditFoodPage.navigate(
      context: context,
      params: EditFoodPageParams(
        foodRecord: foodRecord,
        foodItem: foodItem,
        redirectToDiaryOnLog: true,
        visibleFoodCreator: true,
        visibleRecipeCreator: true,
      ),
    );
  }

  void _onLog({required BuildContext context}) {
    final foodRecord = context.read<FoodScanBloc>().foodRecord;
    final foodItem = context.read<FoodScanBloc>().foodItem;
    context.read<FoodScanBloc>().add(
          DoFoodLogEvent(
            dateTime: DateTime.now(),
            foodItem: foodItem,
            foodRecord: foodRecord,
          ),
        );
  }

  Future<void> _openNutritionFacts() async {
    // await NutritionAI.instance.stopCamera();
    if(mounted) {
      await Navigator.pushNamed(context, Routes.nutritionFacts);
    }
    // await NutritionAI.instance.startCamera();
  }
}
