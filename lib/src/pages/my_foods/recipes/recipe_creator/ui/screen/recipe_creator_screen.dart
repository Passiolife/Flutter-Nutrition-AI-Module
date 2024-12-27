part of '../recipe_creator_page.dart';

class _RecipeCreatorScreen extends StatefulWidget {
  const _RecipeCreatorScreen();

  @override
  State<_RecipeCreatorScreen> createState() => _RecipeCreatorScreenState();
}

class _RecipeCreatorScreenState extends State<_RecipeCreatorScreen> {

  late final RecipeCreatorBloc _bloc = context.read<RecipeCreatorBloc>();

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      final params = NavigationDataProvider.of(context).params;
      _bloc.add(DoPrefillEvent(data: params));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RecipeCreatorBloc, RecipeCreatorState>(
      listener: _handleStateChanges,
      child: Scaffold(
        backgroundColor: AppColors.gray50,
        resizeToAvoidBottomInset: false,
        floatingActionButton: AddIngredientSpeedDialWidget(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: Column(
          children: [
            CustomAppBarWidget(
              title: context.localization?.editRecipe,
              isMenuVisible: false,
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  padding: EdgeInsets.only(top: 16.h),
                  child: Column(
                    children: [
                      const RecipeDetailsSection(),
                      16.verticalSpace,
                      const ServingSizeSection(),
                      16.verticalSpace,
                      const IngredientsSection(),
                      16.verticalSpace,
                    ],
                  ),
                ),
              ),
            ),
            const ActionButtonsSection(),
            (context.bottomPadding + 8).verticalSpace,
          ],
        ),
      ),
    );
  }

  void _handleStateChanges(BuildContext context, RecipeCreatorState state) {
    if (state is SaveRecipeSuccessState) {
      if (state.logUponCreate) {
        context.showSnackbar(
            text: state.userRecipeRecord == null
                ? context.localization?.customRecipeCreatedWithUpdateSuccess
                : context.localization?.customRecipeUpdatedWithUpdateSuccess);
        DashboardPage.navigate(
          context,
          page: 1,
          removeUntil: true,
        );
      } else {
        context.showSnackbar(
            text: state.userRecipeRecord == null
                ? context.localization?.customRecipeCreatedWithSuccess
                : context.localization?.customRecipeUpdatedWithSuccess);
        MyFoodsPage.navigate(context: context, isReplace: true, page: 1);
      }
    }
  }
}
