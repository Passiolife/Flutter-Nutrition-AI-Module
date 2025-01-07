import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../common/constant/app_constants.dart';
import '../../../../common/constant/app_padding.dart';
import '../../../../common/extension/context_extension.dart';
import '../../../../common/models/daily_nutrition_model.dart';
import '../take_photo_result/widgets/meal_time_widget.dart';
import '../take_photo_result/widgets/date_widget.dart';
import 'result_macro_widget.dart';

// class ResultTopWidget extends StatelessWidget {
//   const ResultTopWidget({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     List<DailyNutritionModel> list = [
//       DailyNutritionModel(
//         title: '447',
//         subtitle: '1,512',
//         footer: context.localization!.calories!,
//         value: 0.5,
//         progressColor: AppColors.yellow500,
//         backgroundColor: AppColors.brandPrimaryLight,
//       ),
//       DailyNutritionModel(
//         title: '27 g',
//         subtitle: '170 g',
//         footer: context.localization!.carbs!,
//         value: 0.5,
//         progressColor: AppColors.lBlue500Normal,
//         backgroundColor: AppColors.brandPrimaryLight,
//       ),
//       DailyNutritionModel(
//         title: '17 g',
//         subtitle: '113 g',
//         footer: context.localization!.protein!,
//         value: 0.5,
//         progressColor: AppColors.green500Success,
//         backgroundColor: AppColors.brandPrimaryLight,
//       ),
//       DailyNutritionModel(
//         title: '29 g',
//         subtitle: '42 g',
//         footer: context.localization!.fat!,
//         value: 0.5,
//         progressColor: AppColors.purple500,
//         backgroundColor: AppColors.brandPrimaryLight,
//       ),
//     ];
//
//     return Container(
//       decoration: AppShadows.base,
//       child: Column(
//         children: [
//           (context.topPadding + 48).verticalSpace,
//           AppBar(
//             title: Text(
//               context.localization?.yourResults ?? '',
//               style: AppTextStyle.text2xl.addAll([
//                 AppTextStyle.text2xl.leading8,
//                 AppTextStyle.extraBold
//               ]).copyWith(
//                 color: AppColors.gray900,
//               ),
//             ),
//             centerTitle: true,
//           ),
//           16.verticalSpace,
//           Padding(
//             padding: AppPadding.ph16,
//             child: Row(
//               spacing: 16.w,
//               children: [
//                 Expanded(child: MealTime()),
//                 Expanded(child: TimeStampWidget()),
//               ],
//             ),
//           ),
//           8.verticalSpace,
//           ResultMacrosWidget(listNutrition: list),
//           8.verticalSpace,
//         ],
//       ),
//     );
//   }
// }
