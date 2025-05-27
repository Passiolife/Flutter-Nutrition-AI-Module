import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../common/constant/app_constants.dart';
import '../../../../../../common/extension/context_extension.dart';
import '../../../../../../common/util/debouncer.dart';
import '../../../../../../common/widgets/app_text_field.dart';
import '../../bloc/recipe_creator_bloc.dart';

typedef OnChangeRecipeName = void Function(String name);

class RecipeNameWidget extends StatefulWidget {
  const RecipeNameWidget({super.key});

  @override
  State<RecipeNameWidget> createState() => _RecipeNameWidgetState();
}

class _RecipeNameWidgetState extends State<RecipeNameWidget> {
  late final RecipeCreatorBloc _bloc = context.read<RecipeCreatorBloc>();
  final TextEditingController _controller = TextEditingController();
  final DeBouncer _deBouncer = DeBouncer();

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _attachDebouncer();
    });
    super.initState();
  }

  void _attachDebouncer() {
    _deBouncer.attachToTextController(_controller, () {
      _bloc.add(DoUpdateRecipeNameEvent(name: _controller.text));
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _deBouncer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecipeCreatorBloc, RecipeCreatorState>(
      buildWhen: (_, state) {
        return state is UpdateRecipeNameBuilderState || state is PrefillSuccessState;
      },
      builder: (context, state) {
        String recipeName = '';

        if (state is UpdateRecipeNameBuilderState) {
          recipeName = state.name;
        } else if (state is PrefillSuccessState) {
          recipeName = state.viewModel.recipeName ?? '';
        }

        if (recipeName != _controller.text) {
          _controller.text = recipeName;
        }
        return Padding(
          padding: EdgeInsets.only(top: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.localization?.recipeName ?? '',
                style: AppTextStyle.textSm.addAll([
                  AppTextStyle.textSm.leading5,
                  AppTextStyle.medium
                ]).copyWith(color: AppColors.gray500),
              ),
              4.verticalSpace,
              AppTextField(
                hintText: context.localization?.recipeName ?? '',
                controller: _controller,
                hintStyle: AppTextStyle.textBase
                    .addAll([AppTextStyle.textBase.leading6]).copyWith(
                    color: AppColors.gray500),
                style: AppTextStyle.textBase
                    .addAll([AppTextStyle.textBase.leading6]).copyWith(
                    color: AppColors.gray900),
                textCapitalization: TextCapitalization.sentences,
              ),
            ],
          ),
        );
      },
    );
  }
}
