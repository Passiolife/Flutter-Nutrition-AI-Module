part of '../recipes_page.dart';

class _RecipesScreen extends StatefulWidget {
  const _RecipesScreen({super.key});

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


    // return BlocConsumer<RecipesBloc, RecipesState>(
    //   bloc: _bloc,
    //   listener: (context, state) {
    //     _handleStateChanges(context, state);
    //   },
    //   builder: (context, state) {
    //     return Padding(
    //       padding: EdgeInsets.symmetric(horizontal: 16.w),
    //       child: Column(
    //         children: [
    //           Expanded(
    //             child: SlidableAutoCloseBehavior(
    //               child: ListView.separated(
    //                 shrinkWrap: true,
    //                 padding: EdgeInsets.symmetric(vertical: 16.h),
    //                 itemCount: _list?.length ?? 0,
    //                 physics: const ClampingScrollPhysics(),
    //                 itemBuilder: (context, index) {
    //                   final data = _list?.elementAt(index);
    //                   if (data == null) return const SizedBox.shrink();
    //                   return Slidable(
    //                     key: UniqueKey(),
    //                     // The end action pane is the one at the right or the bottom side.
    //                     endActionPane: ActionPane(
    //                       extentRatio: 0.6,
    //                       motion: const DrawerMotion(),
    //                       dismissible: DismissiblePane(
    //                         onDismissed: () => _doDeleteRecord(data),
    //                       ),
    //                       children: [
    //                         SlidableAction(
    //                           onPressed: (context) => _doEditRecord(data),
    //                           backgroundColor: AppColors.indigo600Main,
    //                           foregroundColor: Colors.white,
    //                           label: context.localization?.edit ?? '',
    //                         ),
    //                         SlidableAction(
    //                           onPressed: (context) => _doDeleteRecord(data),
    //                           backgroundColor: AppColors.red500,
    //                           foregroundColor: Colors.white,
    //                           label: context.localization?.delete ?? '',
    //                         ),
    //                       ],
    //                     ),
    //                     child: FoodItemRowWidget(
    //                       rippleColor: AppColors.white,
    //                       padding: EdgeInsets.all(8.r),
    //                       index: index,
    //                       title: data.name,
    //                       iconId: data.iconId,
    //                       subtitle: data.additionalData,
    //                       onTap: () async {
    //                         _doEditRecord(data);
    //                       },
    //                       onTapAdd: () {
    //                         // _bloc.add(DoFoodLogEvent(foodRecord: data));
    //                       },
    //                       // TODO: handle with true flag.
    //                       enableSlidable: false,
    //                     ),
    //                   );
    //                 },
    //                 separatorBuilder: (BuildContext context, int index) {
    //                   return 8.verticalSpace;
    //                 },
    //               ),
    //             ),
    //           ),
    //           AppButton(
    //             buttonText: context.localization?.createNewRecipe,
    //             appButtonModel: AppButtonStyles.primary,
    //             onTap: _doCreateNewFood,
    //           ),
    //         ],
    //       ),
    //     );
    //   },
    // );
  }

  void _handleStateChanges(BuildContext context, RecipesState state) {
    if (state is LogSuccessState) {
      context.showSnackbar(text: context.localization?.itemAddedToDiary);
    }
  }
}
