part of '../take_photo_page.dart';

class _TakePhotoScreen extends StatefulWidget {
  const _TakePhotoScreen({super.key});

  @override
  State<_TakePhotoScreen> createState() => _TakePhotoScreenState();
}

class _TakePhotoScreenState extends State<_TakePhotoScreen> {
  bool _seenIntroDialog = true;

  TakePhotoBloc? get _bloc => mounted ? context.read<TakePhotoBloc>() : null;

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      /*ShowWidgetUtil.showCustomModalBottomSheet(
        context: context,
        isDismissible: false,
        isScrollControlled: true,
        backgroundColor: context.theme.scaffoldBackgroundColor,
        builder: (bsContext) {
          return ResultSection();
        },
      );*/
      // Navigator.pushNamed(context, Routes.takePhotoResult);
      _bloc?.add(const DoCheckIntroScreenEvent());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TakePhotoBloc, TakePhotoState>(
      listener: (context, state) {
        _handleStateChanges(context, state);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: _seenIntroDialog
            ? Column(
                children: [
                  TakePhotoHeaderSection(),
                  Expanded(
                    child: Stack(
                      children: [
                        const CameraSection(),
                        const CameraFrameSection(),
                        const CapturedImagesSection(),
                      ],
                    ),
                  ),
                ],
              )
            : const SizedBox.shrink(),
      ),
    );
  }

  void _handleStateChanges(BuildContext context, TakePhotoState state) {
    if (state is ShowIntroDialogListenerState) {
      ShowWidgetUtil.showCustomGeneralDialog(
        context: context,
        builder: (BuildContext context) {
          return IntroWidget(
            onTap: () {
              Navigator.pop(context);
              _bloc?.add(const DoIntroScreenCompletedEvent(fromDialog: true));
            },
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
