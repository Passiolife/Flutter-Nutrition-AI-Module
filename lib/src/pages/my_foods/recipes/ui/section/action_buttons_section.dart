import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../common/constant/app_button_styles.dart';
import '../../../../../common/util/context_extension.dart';
import '../../../../../common/widgets/app_button.dart';
import '../../bloc/recipes_bloc.dart';
import '../../recipe_creator/ui/recipe_creator_page.dart';

class ActionButtonsSection extends StatelessWidget {
  const ActionButtonsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return AppButton(
      buttonText: context.localization?.createNewRecipe,
      appButtonModel: AppButtonStyles.primary,
      onTap: () => _doCreateNewFood(context: context),
    );
  }

  Future<void> _doCreateNewFood({required BuildContext context}) async {
    await RecipeCreatorPage.navigate(context: context);
    if (context.mounted) {
      _fetchUserRecipes(context: context);
    }
  }

  void _fetchUserRecipes({required BuildContext context}) {
    context.read<RecipesBloc>().add(const FetchUserRecipeEvent());
  }
}
