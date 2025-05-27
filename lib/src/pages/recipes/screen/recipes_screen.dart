part of '../recipes_page.dart';

class _RecipesScreen extends StatelessWidget {
  const _RecipesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<RecipesBloc, RecipesState>(
      listener: _handleStateChanges,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              const RecipeListSection(),
              const ActionButtonsSection(),
              8.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }

  void _handleStateChanges(BuildContext context, RecipesState state) {
    // if (state is LogSuccessState) {
    //   context.showSnackbar(text: context.localization.itemAddedToDiary);
    // }
  }
}