import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../common/constant/app_shadow.dart';
import '../../bloc/recipe_creator_bloc.dart';
import '../widgets/serving_size_selector_widget.dart';
import '../widgets/serving_size_title_widget.dart';

class ServingSizeSection extends StatelessWidget {
  const ServingSizeSection({super.key});

  @override
  Widget build(BuildContext context) {
    final ingredients = context.watch<RecipeCreatorBloc>().viewModel.foodRecord?.ingredients;
    return Visibility(
      visible: ingredients?.isNotEmpty ?? false,
      child: Container(
        decoration: AppShadows.base,
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ServingSizeTitleWidget(),
            16.verticalSpace,
            const ServingSizeSelectorWidget(),
          ],
        ),
      ),
    );
  }
}
