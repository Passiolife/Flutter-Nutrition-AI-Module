import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../common/constant/app_images.dart';
import '../../../../../../common/models/food_record/food_record.dart';
import '../../../../../../common/widgets/edit_image_widget.dart';
import '../../bloc/recipe_creator_bloc.dart';

class RecipeImageWidget extends StatelessWidget {
  const RecipeImageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecipeCreatorBloc, RecipeCreatorState>(
      buildWhen: (_, state) {
        return state is UpdateImageBuilderState || state is PrefillSuccessState;
      },
      builder: (context, state) {
        String? iconId;
        if (state is PrefillSuccessState) {
          iconId = state.viewModel.foodRecord?.iconId;
          if((iconId?.replaceAll(FoodRecord.userRecipePrefix, '').isEmpty ?? true)) {
            iconId = null;
          }
        }

        Uint8List? image;
        if (state is UpdateImageBuilderState) {
          image = state.image;
        } else if (state is PrefillSuccessState) {
          image = state.viewModel.image;
        }

        return EditImageWidget(
          defaultImage: AppImages.icRecipe,
          iconId: iconId,
          image: image,
          onChange: (image) => _handleOnChange(context: context, image: image),
        );
      },
    );
  }

  void _handleOnChange({
    required BuildContext context,
    Uint8List? image,
  }) {
    context.read<RecipeCreatorBloc>().add(DoUpdateImageEvent(image: image));
  }
}
