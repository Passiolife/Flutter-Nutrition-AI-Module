import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../nutrition_ai_module.dart';
import '../../../common/extension/context_extension.dart';
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
        PassioFoodItem? foodItem;
        String? iconId;
        String? title;
        String? subtitle;
        if (state is BarcodeNotRecognizedStateNew ||
            state is AddedToDiaryVisibilityState) {
          return const SizedBox.shrink();
        } else if (state is ScanResultState) {
          foodItem = state.foodItem;
          iconId = foodItem?.iconId;
          title = foodItem?.name;
          subtitle =
              '${context.localization?.upc ?? ''}: ${foodItem?.ingredients.firstOrNull?.metadata.barcode ?? ''}';
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
                    onEdit: () => _onEdit(context: context, foodItem: foodItem),
                    onLog: () => _onLog(context: context, foodItem: foodItem),
                  )
                : ScanningWidget(),
          ),
        );
      },
    );
  }

  void _onEdit({required BuildContext context, PassioFoodItem? foodItem}) {
    EditFoodPage.navigate(
      context: context,
      params: EditFoodPageParams(
        foodItem: foodItem,
        redirectToDiaryOnLog: true,
        visibleFoodCreator: true,
        visibleRecipeCreator: true,
      ),
    );
  }

  void _onLog({required BuildContext context, PassioFoodItem? foodItem}) {
    context.read<FoodScanBloc>().add(DoFoodLogEvent(
          dateTime: DateTime.now(),
          foodItem: foodItem,
        ));
  }
}
