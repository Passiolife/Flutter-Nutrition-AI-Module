import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/widgets/daily_nutrition_widget.dart';
import '../../dashboard/bloc/dashboard_bloc.dart';
import '../bloc_/home_bloc.dart';

class DailyNutritionSection extends StatelessWidget {
  const DailyNutritionSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      buildWhen: (_, state) {
        return state is HomeInitial || state is UpdateDailyNutritionState;
      },
      builder: (context, state) {
        int? consumedCalories;
        double? totalCalories;
        int? consumedCarbs;
        double? totalCarbs;
        int? consumedProteins;
        double? totalProteins;
        int? consumedFat;
        double? totalFat;

        if(state is UpdateDailyNutritionState) {
          consumedCalories = state.consumedCalories;
          totalCalories = state.totalCalories;
          consumedCarbs = state.consumedCarbs;
          totalCarbs = state.totalCarbs;
          consumedProteins = state.consumedProteins;
          totalProteins = state.totalProteins;
          consumedFat = state.consumedFat;
          totalFat = state.totalFat;
        }

        return DailyNutritionWidget(
          consumedCalories: consumedCalories,
          totalCalories: totalCalories,
          consumedCarbs: consumedCarbs,
          totalCarbs: totalCarbs,
          consumedProteins: consumedProteins,
          totalProteins: totalProteins,
          consumedFat: consumedFat,
          totalFat: totalFat,
          onTap: () => _onTap(context: context),
        );
      },
    );
  }

  void _onTap({required BuildContext context}) {
    final bloc = BlocProvider.of<DashboardBloc>(context);
    bloc.add(const PageUpdateEvent(index: 4));
  }
}
