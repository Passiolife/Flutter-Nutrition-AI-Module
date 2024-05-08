import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/constant/app_constants.dart';
import '../../../common/models/food_record/food_record.dart';
import '../../../common/models/micro_nutrient/micro_nutrient.dart';
import 'widgets/widgets.dart';

class NutritionInformationPage extends StatelessWidget {
  const NutritionInformationPage({this.foodRecord, super.key});

  final FoodRecord? foodRecord;

  static Future navigate(
      {required BuildContext context, FoodRecord? foodRecord}) {
    return Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                NutritionInformationPage(foodRecord: foodRecord)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray50,
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          const NutritionInformationAppBar(),
          SizedBox(height: AppDimens.h16),
          const NutritionInformationMessageWidget(),
          SizedBox(height: AppDimens.h24),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.r),
              child: NutritionInformationWidget(
                nutrientList: MicroNutrient.nutrientsFromFoodRecord(foodRecord),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
