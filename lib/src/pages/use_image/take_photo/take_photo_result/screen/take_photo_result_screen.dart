part of '../take_photo_result_page.dart';

class _TakePhotoResultScreen extends StatefulWidget {
  const _TakePhotoResultScreen({super.key});

  @override
  State<_TakePhotoResultScreen> createState() => _TakePhotoResultScreenState();
}

class _TakePhotoResultScreenState extends State<_TakePhotoResultScreen> {
  TakePhotoResultBloc? get _bloc =>
      mounted ? context.read<TakePhotoResultBloc>() : null;

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      final navigationData = TakePhotoResultNavigationDataProvider.of(context);
      final capturedImages = navigationData.capturedImages;
      _bloc?.add(DoProcessEvent(images: capturedImages));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TakePhotoResultBloc, TakePhotoResultState>(
      listener: _handleStateChanges,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: AppShadows.base,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const ResultHeaderSection(),
                  const MacrosGraphSection(),
                ],
              ),
            ),
            const GeneratingResultsSection(),
            // const BarcodeMissingDataWidget(),
            const FoodItemsListSection(),
            const NoResultsFoundSection(),
            const ActionButtonsSection(),
            context.bottomPaddingValue.verticalSpace,
          ],
        ),
      ),
    );
  }

  void _handleStateChanges(BuildContext context, TakePhotoResultState state) {
    if (state is FoodLogSuccessState) {
      _showItemAddedToDiary(context);
    } else if(state is CreateRecipeSuccessState) {
      final foodRecord = state.foodRecord;
      final recipeData = RecipeCreatorNavigationData(
        loggedFoodRecord: foodRecord
      );
      Navigator.pushNamed(context, Routes.recipeCreator, arguments: recipeData);
    }
  }

  void _showItemAddedToDiary(BuildContext context) {
    ShowWidgetUtil.showCustomGeneralDialog(
      context: context,
      builder: (dsContext) {
        return ItemAddedToDiaryWidget(
          onTapNegative: () {
            Navigator.pushNamedAndRemoveUntil(
              context,
              Routes.dashboard,
              (route) => route.isFirst,
              arguments: 1,
            );
          },
          onTapPositive: () {
            Navigator.popUntil(
                context, (route) => route.settings.name == Routes.takePhoto);
          },
        );
      },
    );
  }
}
