import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/constant/app_constants.dart';
import '../../../common/models/food_record/food_record.dart';
import '../../../common/models/micro_nutrient/micro_nutrient.dart';
import '../../../common/util/context_extension.dart';
import '../../../common/widgets/custom_app_bar_widget.dart';
import '../../../common/widgets/food_item_row_widget.dart';
import 'widgets/nutrient_table_widget.dart';
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
          CustomAppBarWidget(
            title: context.localization?.nutritionInformation,
            isMenuVisible: false,
          ),
          16.verticalSpace,
          const NutritionInformationMessageWidget(),
          16.verticalSpace,
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16.w),
            padding: EdgeInsets.all(8.r),
            decoration: AppShadows.base,
            child: FoodItemRowWidget(
              iconId: foodRecord?.iconId,
              title: foodRecord?.name,
              subtitle: foodRecord?.additionalData,
              isAddVisible: false,
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: NutrientTableWidget(
                nutrientList: MicroNutrient.nutrientsFromFoodRecord(foodRecord),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
