part of '../recipes_page.dart';

class _RecipesScreen extends StatefulWidget {
  const _RecipesScreen();

  @override
  State<_RecipesScreen> createState() => _RecipesScreenState();
}

class _RecipesScreenState extends State<_RecipesScreen> {

  RecipesBloc get _bloc => context.read<RecipesBloc>();

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _fetchUserRecipes();
    });
    super.initState();
  }

  void _fetchUserRecipes() {
    _bloc.add(const FetchUserRecipeEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RecipesBloc, RecipesState>(
      listener: _handleStateChanges,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          children: [
            Expanded(child: RecipeListSection()),
            ActionButtonsSection(),
          ],
        ),
      ),
    );
  }

  void _handleStateChanges(BuildContext context, RecipesState state) {
    if (state is LogSuccessState) {
      context.showSnackbar(text: context.localization?.itemAddedToDiary);
    }
  }
}
