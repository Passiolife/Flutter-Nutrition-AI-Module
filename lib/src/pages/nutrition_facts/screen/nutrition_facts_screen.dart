part of '../nutrition_facts_page.dart';

class _NutritionFactsScreen extends StatefulWidget {
  const _NutritionFactsScreen();

  @override
  State<_NutritionFactsScreen> createState() => _NutritionFactsScreenState();
}

class _NutritionFactsScreenState extends State<_NutritionFactsScreen> {
  bool _seenIntroDialog = true;

  NutritionFactsBloc? get _bloc => mounted ? context.read<NutritionFactsBloc>() : null;

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _bloc?.add(const DoCheckIntroScreenEvent());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NutritionFactsBloc, NutritionFactsState>(
      listener: (context, state) {
        _handleStateChanges(context, state);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: _seenIntroDialog
            ? Column(
                children: [
                  const HeaderSection(),
                  Expanded(
                    child: Stack(
                      children: [
                        const CameraSection(),
                        // const CameraFrameSection(),
                        // const CapturedImagesSection(),
                      ],
                    ),
                  ),
                ],
              )
            : const SizedBox.shrink(),
      ),
    );
  }

  void _handleStateChanges(BuildContext context, NutritionFactsState state) {
    if (state is ShowIntroDialogListenerState) {
      ShowWidgetUtil.showCustomGeneralDialogNew(
        context: context,
        builder: (BuildContext context) {
          return const CaptureNutritionFactsLabelWidget(
            // onTap: () {
            //   Navigator.pop(context);
            //   _bloc?.add(const DoIntroScreenCompletedEvent(fromDialog: true));
            // },
          );
        },
      );
    }
    // if (state is ListenerState) {
    //   switch (state) {
    //     case TakePhotoInitialListenerState():
    //       _originalImages.clear();
    //       _thumbImages.clear();
    //       _advisorFoodInfoList = null;
    //       break;
    //     case TakePhotoSuccessListenerState():
    //       _originalImages.insert(0, state.originalBytes);
    //       _thumbImages.insert(0, state.compressedBytes);
    //       break;
    //     case RemovePhotoListenerState():
    //       _originalImages.removeAt(state.index);
    //       _thumbImages.removeAt(state.index);
    //       break;
    //     case RecognizeImageLoadingListenerState():
    //       _isNextLoading = true;
    //       break;
    //     case RecognizeImageSuccessListenerState():
    //       _isNextLoading = false;
    //       _advisorFoodInfoList = state.data;
    //       _originalImages.clear();
    //       _thumbImages.clear();
    //       if (_advisorFoodInfoList?.isEmpty ?? true) {
    //         ShowWidgetUtil.showCustomModalBottomSheet(
    //           context: context,
    //           builder: (bsContext) {
    //             return NoResultsFoundBottomSheet(
    //               height: 222.h,
    //               onTapNegative: () {
    //                 Navigator.pop(bsContext);
    //               },
    //               onTapPositive: () {
    //                 _onTapSearch(context: context);
    //               },
    //             );
    //           },
    //         );
    //       }
    //       break;
    //     case FoodLogLoadingListenerState():
    //       _visibleLoadingForLog = true;
    //       break;
    //     case FoodLogSuccessListenerState():
    //       _visibleLoadingForLog = false;
    //       context.showSnackbar(text: context.localization?.itemAddedToDiary);
    //       DashboardPage.navigate(
    //         context,
    //         page: 1,
    //         removeUntil: true,
    //       );
    //       break;
    //     case FoodLogFailureListenerState():
    //       _visibleLoadingForLog = false;
    //       context.showSnackbar(text: context.localization?.foodLogErrorMessage);
    //       break;
    //     case ShowIntroDialogListenerState():
    //       IntroDialog.show(
    //         context: context,
    //         onTapOk: (context) {
    //           Navigator.pop(context);
    //           _bloc.add(const DoIntroScreenCompletedEvent(fromDialog: true));
    //         },
    //       );
    //       break;
    //     case IntroDialogSeenListenerState():
    //       _seenIntroDialog = true;
    //       break;
    //   }
    // }
  }
}
