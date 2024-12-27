import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../common/constant/app_constants.dart';
import '../../../../../../common/extension/context_extension.dart';
import '../widgets/recipe_image_widget.dart';
import '../widgets/recipe_name_widget.dart';

class RecipeDetailsSection extends StatelessWidget {
  const RecipeDetailsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppShadows.base,
      padding: EdgeInsets.all(16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.localization?.recipeDetails ?? '',
            style: AppTextStyle.textBase.addAll([
              AppTextStyle.textBase.leading6,
              AppTextStyle.semiBold,
            ]).copyWith(color: AppColors.black),
          ),
          16.verticalSpace,
          Stack(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const RecipeImageWidget(),
                  16.horizontalSpace,
                  const Expanded(
                    child: RecipeNameWidget(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
