import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrition_ai/nutrition_ai.dart';

import '../../common/constant/app_constants.dart';
import '../../common/router/routes.dart';
import '../edit_food/ui/edit_food_page.dart';
import '../food_search/food_search_page.dart';
import '../my_foods/custom_foods/food_creator/food_creator_page.dart';
import 'bloc/food_scan_bloc.dart';
import 'screen/food_scan_screen.dart';
import 'widgets/nutrition_facts_result_widget.dart';
import 'widgets/widgets.dart';

class FoodScanPage extends StatefulWidget {
  const FoodScanPage({required this.selectedDateTime, super.key});

  final DateTime selectedDateTime;

  static MaterialPageRoute route({required DateTime selectedDateTime}) {
    return MaterialPageRoute(
      settings: RouteSettings(name: Routes.foodScan),
      builder: (_) => FoodScanPage(selectedDateTime: selectedDateTime),
    );
  }

  static Future navigate(BuildContext context, {DateTime? selectedDateTime}) {
    return Navigator.pushNamed(
      context,
      Routes.foodScan,
      arguments: selectedDateTime,
    );
  }

  @override
  State<FoodScanPage> createState() => _FoodScanPageState();
}

class _FoodScanPageState extends State<FoodScanPage>
    with TickerProviderStateMixin
    implements FoodScanListener, NutritionFactsHandler {
  // Bloc instance responsible for managing the state of the FoodScan feature
  final FoodScanBloc _bloc = FoodScanBloc();

  PassioFoodItem? _foodItem;
  DetectedCandidate? _detectedCandidate;
  final List<DetectedCandidate> _alternatives = [];

  PassioNutritionFacts? _nutritionFacts;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FoodScanBloc(),
      child: FoodScanScreen(),
    );
  }

  @override
  void onDragResult(bool isCollapsed) {
    if (isCollapsed) {
      Future.delayed(const Duration(milliseconds: AppDimens.duration150), () {
        _bloc.add(ScanResultDragEvent(isCollapsed: isCollapsed));
      });
    } else {
      // _scanningAnimationKey.currentState?.stopScanningAnimation();
      _bloc.add(ScanResultDragEvent(isCollapsed: isCollapsed));
    }
  }

  @override
  Future<void> onEdit(int? index) async {
    DetectedCandidate? candidate;
    if (index != null) {
      candidate = _alternatives.elementAt(index);
    } else {
      candidate = _detectedCandidate;
    }
    EditFoodPage.navigate(
      context: context,
      params: EditFoodPageParams(
        foodItem: _foodItem,
        detectedCandidate: candidate,
        redirectToDiaryOnLog: true,
        visibleFoodCreator: true,
        visibleRecipeCreator: true,
      ),
    );
  }

  @override
  void onLog() {
    _bloc.add(DoFoodLogEvent(
        dateTime: DateTime.now(),
        foodItem: _foodItem,
        detectedCandidate: _detectedCandidate));
  }

  @override
  void onTapSearch() {
    FoodSearchPage.navigate(context, needsReturn: false);
  }

  // NutritionFactsHandler methods
  @override
  void onCancel() {
    _bloc.add(const ClearNutritionFactsEvent());
  }

  @override
  void onNext() {
    FoodCreatorPage.navigate(
      context: context,
      nutritionFacts: _nutritionFacts,
    );
  }
// END: NutritionFactsHandler methods
}
