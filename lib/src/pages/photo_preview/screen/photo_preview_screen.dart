part of '../photo_preview_page.dart';

class _PhotoPreviewScreen extends StatefulWidget {
  const _PhotoPreviewScreen();

  @override
  State<_PhotoPreviewScreen> createState() => _PhotoPreviewScreenState();
}

class _PhotoPreviewScreenState extends State<_PhotoPreviewScreen> {

  late NavigationDataProvider navigationData = NavigationDataProvider.of(context);

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      final file = navigationData.file;

      context.read<PhotoPreviewBloc>().add(DoProcessEvent(file: file));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final file = navigationData.file;
    return BlocListener<PhotoPreviewBloc, PhotoPreviewState>(
      listener: _handleStateChanges,
      child: Scaffold(
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
    if(state is NutritionFactsFoundState) {
      EditNutritionFactsPage.navigate(context: context, foodRecord: state.foodRecord);
    }else if (state is BothNotFoundState) {
      _showNutritionFactsNotFoundDialog(context: context);
    } else if(state is NutritionFactsNotFoundState) {
      _showNutritionFactsNotFoundDialog(context: context);
    } else if(state is IngredientsNotFoundState) {
      _showIngredientsNotFoundDialog(context: context);
    } else if(state is FailedToAnalyzedState) {
      _showFailedToAnalyzedState(context: context);
    }
  }

  void _showNutritionFactsNotFoundDialog({required BuildContext context}) {
    ShowWidgetUtil.showCustomGeneralDialogNew(
      context: context,
      builder: (BuildContext context) {
        return NoNutritionFactsLabelFoundWidget(
          // onTap: () {
          //   Navigator.pop(context);
          //   _bloc?.add(const DoIntroScreenCompletedEvent(fromDialog: true));
          // },
        );
      },
    );
  }

  void _showIngredientsNotFoundDialog({required BuildContext context}) {
    ShowWidgetUtil.showCustomGeneralDialogNew(
      context: context,
      builder: (BuildContext context) {
        return NoIngredientsLabelFoundWidget(
          // onTap: () {
          //   Navigator.pop(context);
          //   _bloc?.add(const DoIntroScreenCompletedEvent(fromDialog: true));
          // },
        );
      },
    );
  }

  void _showFailedToAnalyzedState({required BuildContext context}) {
    // ShowWidgetUtil.showCustomGeneralDialogNew(
    //   context: context,
    //   builder: (BuildContext context) {
    //     return FailedToAnalyzeImageWidget(
    //       // onTap: () {
    //       //   Navigator.pop(context);
    //       //   _bloc?.add(const DoIntroScreenCompletedEvent(fromDialog: true));
    //       // },
    //     );
    //   },
    // );
  }
}
