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
      _showItemAddedToDiary(context: context, foodLogCount: state.foodLogCount, customFoodCount: state.customFoodCount);
    } else if(state is CustomFoodCreatedState) {
      _showCustomFoodCreatedDialog(context);
    }
  }

  void _showCustomFoodCreatedDialog(BuildContext context) {
    ShowWidgetUtil.showCustomGeneralDialogNew(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const CustomFoodCreatedWidget();
      },
    );
  }

  void _showItemAddedToDiary({required BuildContext context, required int foodLogCount, required int customFoodCount}) {
    ShowWidgetUtil.showCustomGeneralDialog(
      barrierDismissible: false,
      context: context,
      builder: (dContext) {
        final diaryMessage =  '$foodLogCount ${foodLogCount > 1 ? context.localization.itemsAddedToDiary : context.localization.itemAddedToDiary}';
        final customFoodMessage = customFoodCount > 0 ? '\n$customFoodCount ${context.localization.customFoodCreated}' : '';
        final title = '$diaryMessage$customFoodMessage';
        return ItemAddedToDiaryWidget(
          title: title,
          subtitle: context.localization.viewYourDiaryOrAddMore,
          positiveText: context.localization.addMore.toUpperCaseWord,
          onTapNegative: () {
            Navigator.pushNamedAndRemoveUntil(
              context,
              Routes.dashboard,
              (route) => route.isFirst,
              arguments: 1,
            );
          },
          onTapPositive: () {
            Navigator.pop(context);
          },
        );
      },
    );
  }
}
