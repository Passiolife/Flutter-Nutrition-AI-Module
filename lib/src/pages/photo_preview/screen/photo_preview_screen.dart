part of '../photo_preview_page.dart';

class _PhotoPreviewScreen extends StatefulWidget {
  const _PhotoPreviewScreen();

  @override
  State<_PhotoPreviewScreen> createState() => _PhotoPreviewScreenState();
}

class _PhotoPreviewScreenState extends State<_PhotoPreviewScreen> {
  late final _navigationData = NavigationDataProvider.of(context);

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      final file = _navigationData.file;

      context.read<PhotoPreviewBloc>().add(DoProcessEvent(file: file));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final file = _navigationData.file;
    return BlocListener<PhotoPreviewBloc, PhotoPreviewState>(
      listener: _handleStateChanges,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            CustomAppBar(title: context.localization.photoPreview),
            16.verticalSpace,
            Expanded(
              flex: 2,
              child: ImagePreviewSection(file: file),
            ),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  AnalyzeProgressSection(),
                  ActionButtonWidget(),
                  (context.bottomPaddingValue + 16).verticalSpace,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleStateChanges(BuildContext context, PhotoPreviewState state) {
    if (state is NutritionFactsFoundState) {
      /*EditNutritionFactsPage.navigate(
        context: context,
        foodRecord: state.foodRecord,
        imageBytes: state.imageBytes,
        barcode: navigationData.barcode,
      );*/
      _showEditNutritionFactsPage(
        context: context,
        foodRecord: state.foodRecord,
        imageBytes: state.imageBytes,
        barcode: _navigationData.barcode,
      );
    } /*else if (state is BothNotFoundState) {
      _showNutritionFactsNotFoundDialog(context: context);
    } */else if (state is NutritionFactsNotFoundState) {
      _showNutritionFactsNotFoundDialog(context: context, imageBytes: state.imageBytes);
    } /*else if (state is IngredientsNotFoundState) {
      _showIngredientsNotFoundDialog(context: context);
    } else if (state is FailedToAnalyzedState) {
      _showFailedToAnalyzedState(context: context);
    }*/ else if (state is SaveSuccessState) {
      _showItemAddedToDiary(context);
    }
  }

  Future<void> _showEditNutritionFactsPage({
    required BuildContext context,
    FoodRecord? foodRecord,
    Uint8List? imageBytes,
    String? barcode,
  }) async {
    final FoodRecord? newFoodRecord = await EditNutritionFactsPage.navigate(
      context: context,
      foodRecord: foodRecord,
      imageBytes: imageBytes,
      barcode: barcode,
      visibleSubtitle: true,
      routeName: Routes.photoPreview,
    );
    if(!context.mounted) {
      return;
    }
    if(newFoodRecord == null) {
      Navigator.pop(context);
    }
    context.read<PhotoPreviewBloc>().add(SaveEvent(foodRecord: newFoodRecord!, imageBytes: imageBytes!));
  }

  void _showNutritionFactsNotFoundDialog({required BuildContext context, required Uint8List imageBytes}) {
    ShowWidgetUtil.showCustomGeneralDialogNew(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dsContext) {
        return NoNutritionFactsLabelFoundWidget(
          onTapNegative: () {
            Navigator.pop(dsContext);
            Navigator.pop(context);
          },
          onTapPositive: () {
            Navigator.pop(dsContext);
            _showEditNutritionFactsPage(context: context, imageBytes: imageBytes, barcode: _navigationData.barcode);
          },
        );
      },
    );
  }

  void _showItemAddedToDiary(BuildContext context) {
    ShowWidgetUtil.showCustomGeneralDialog(
      context: context,
      barrierDismissible: false,
      builder: (dContext) {
        return ItemAddedToDiaryWidget(
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
            Navigator.popUntil(
                context, (route) => route.settings.name == Routes.foodScan);
          },
        );
      },
    );
  }
}
