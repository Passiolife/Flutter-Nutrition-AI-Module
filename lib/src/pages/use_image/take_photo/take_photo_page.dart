import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/router/routes.dart';
import '../../../common/util/show_widget_util.dart';
import 'bloc/take_photo_bloc.dart';
import 'models/take_photo_navigation_data_provider.dart';
import 'sections/camera_frame_section.dart';
import 'sections/camera_section.dart';
import 'sections/captured_images_section.dart';
import 'sections/take_photo_header_section.dart';
import 'widgets/intro_widget.dart';

part 'screen/take_photo_screen.dart';

class TakePhotoPage extends StatefulWidget {
  const TakePhotoPage({
    required this.returnResult,
    required this.maxLimit,
    super.key,
  });

  final bool returnResult;

  // Maximum number of images allowed to be stored
  final int maxLimit;

  static MaterialPageRoute route({
    required bool returnResult,
    required int maxLimit,
  }) {
    return MaterialPageRoute(
      settings: RouteSettings(name: Routes.takePhoto),
      builder: (_) => TakePhotoPage(
        returnResult: returnResult,
        maxLimit: maxLimit,
      ),
    );
  }

  static Future navigate(BuildContext context,
      {bool returnResult = false, int maxLimit = 7}) async {
    return await Navigator.pushNamed(
      context,
      Routes.takePhoto,
      arguments: [returnResult, maxLimit],
    );
  }

  @override
  State<TakePhotoPage> createState() => _TakePhotoPageState();
}

class _TakePhotoPageState extends State<TakePhotoPage> {
  // final _bloc = TakePhotoBloc();
  //
  // // GlobalKey to uniquely identify the CameraWidget's state and access it
  // final _cameraKey = GlobalKey<CameraWidgetState>();
  //
  // // Lists to store the original images and their thumbnails
  // final List<Uint8List> _originalImages = [];
  // final List<Uint8List> _thumbImages = [];
  //
  // bool _isNextLoading = false;
  //
  // List<AdvisorFoodInfoLog>? _advisorFoodInfoList;
  //
  // bool _visibleLoadingForLog = false;
  //
  // bool _seenIntroDialog = false;
  //
  // @override
  // void initState() {
  //   _bloc.add(const DoCheckIntroScreenEvent());
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return TakePhotoNavigationDataProvider(
      returnResult: widget.returnResult,
      maxLimit: widget.maxLimit,
      child: BlocProvider(
        create: (context) => TakePhotoBloc(),
        child: _TakePhotoScreen(),
      ),
    );
    // return BlocConsumer(
    //   bloc: _bloc,
    //   listener: (context, state) {
    //     _handleStateChanges(context, state);
    //   },
    //   builder: (context, state) {
    //     return Scaffold(
    //       backgroundColor: AppColors.gray50,
    //       resizeToAvoidBottomInset: false,
    //       body: _seenIntroDialog
    //           ? Stack(
    //               fit: StackFit.expand,
    //               children: [
    //                 CameraWidget(
    //                   key: _cameraKey,
    //                   resolution: ResolutionPreset.veryHigh,
    //                 ),
    //                 ActionButtonsWidget(
    //                   onNegativeTap: () {
    //                     Navigator.pop(context);
    //                   },
    //                   captureEnabled: _originalImages.length < widget.maxLimit,
    //                   onCapture: () {
    //                     _takePicture();
    //                   },
    //                   positiveEnabled: _thumbImages.isNotEmpty,
    //                   visibleLoadingForPositiveButton: _isNextLoading,
    //                   onPositiveTap: () {
    //                     if (widget.returnResult) {
    //                       Navigator.pop(context, _originalImages);
    //                       return;
    //                     }
    //                     _bloc.add(DoNextEvent(images: _originalImages));
    //                   },
    //                 ),
    //                 CarouselSliderWidget(
    //                   images: _thumbImages,
    //                   onDelete: (index) {
    //                     _bloc.add(DoRemoveImageEvent(index: index));
    //                   },
    //                 ),
    //                 Positioned(
    //                   top: 194.h,
    //                   left: 24.w,
    //                   right: 24.w,
    //                   child: CameraFrameWidget(height: 380.h),
    //                 ),
    //                 _advisorFoodInfoList?.isNotEmpty ?? false
    //                     ? ResultWidget(
    //                         title: context.localization?.result ?? '',
    //                         subtitle: ((_advisorFoodInfoList?.length ?? 0) > 0)
    //                             ? context.localization?.resultDescription ?? ''
    //                             : '',
    //                         data: _advisorFoodInfoList,
    //                         clearVisible:
    //                             _advisorFoodInfoList?.hasSelectedItems() ??
    //                                 false,
    //                         itemBuilder: (BuildContext context, int index) {
    //                           final data =
    //                               _advisorFoodInfoList?.elementAt(index);
    //
    //                           final advisorInfo = data?.advisorFoodInfoModel;
    //
    //                           final foodDataInfo = advisorInfo?.foodDataInfo;
    //                           final iconId = foodDataInfo?.iconID ?? '';
    //                           final title = foodDataInfo?.foodName ?? '';
    //                           final calories =
    //                               foodDataInfo?.nutritionPreview.calories ?? 0;
    //
    //                           final servingQuantity = foodDataInfo
    //                                   ?.nutritionPreview.servingQuantity ??
    //                               0;
    //                           final servingUnit =
    //                               foodDataInfo?.nutritionPreview.servingUnit ??
    //                                   '';
    //                           final formattedWeight =
    //                               '$servingQuantity $servingUnit';
    //
    //                           final subtitle =
    //                               '$formattedWeight | $calories ${context.localization?.cal}';
    //
    //                           final isSelected = data?.isSelected ?? false;
    //
    //                           return FoodItemRowWidget(
    //                             data: FoodItemRowData(
    //                               iconId: iconId,
    //                               title: title,
    //                               subtitle: subtitle,
    //                               isAddVisible: false,
    //                               padding: EdgeInsets.zero,
    //                               decoration: BoxDecoration(
    //                                   color: isSelected
    //                                       ? AppColors.indigo50
    //                                       : null),
    //                               suffix: IconButton(
    //                                 onPressed: () {
    //                                   if (data != null) {
    //                                     _bloc.add(UpdateSelectionEvent(
    //                                         data: _advisorFoodInfoList,
    //                                         index: index));
    //                                   }
    //                                 },
    //                                 icon: SelectionIndicator(
    //                                     isSelected: isSelected),
    //                               ),
    //                               onTap: () {
    //                                 if (data != null) {
    //                                   _bloc.add(UpdateSelectionEvent(
    //                                       data: _advisorFoodInfoList,
    //                                       index: index));
    //                                 }
    //                               },
    //                               enableSlidable: false,
    //                             ),
    //                           );
    //                         },
    //                         emptyBuilder: () {
    //                           return Center(
    //                             child: Text(
    //                               context.localization?.noResultsFound ?? '',
    //                               style: AppTextStyle.textSm,
    //                             ),
    //                           );
    //                         },
    //                         onClear: () {
    //                           _bloc.add(ClearSelectionEvent(
    //                               data: _advisorFoodInfoList));
    //                         },
    //                         neutralButtonText: context.localization?.retake,
    //                         onNeutralClick: () {
    //                           _bloc.add(const InitialEvent());
    //                         },
    //                         negativeButtonText: context.localization?.cancel,
    //                         onNegativeClick: () {
    //                           Navigator.pop(context);
    //                         },
    //                         positiveButtonText:
    //                             context.localization?.logSelected,
    //                         positiveButtonEnabled:
    //                             _advisorFoodInfoList?.hasSelectedItems() ??
    //                                 false,
    //                         visibleLoadingForPositiveButton:
    //                             _visibleLoadingForLog,
    //                         onPositiveClick: () {
    //                           _bloc.add(
    //                               DoFoodLogEvent(data: _advisorFoodInfoList));
    //                         },
    //                       )
    //                     : const SizedBox.shrink(),
    //               ],
    //             )
    //           : const SizedBox.shrink(),
    //     );
    //   },
    // );
  }

/*@override
  void dispose() {
    _bloc.close();
    _advisorFoodInfoList = null;
    super.dispose();
  }

  void _handleStateChanges(BuildContext context, Object? state) {
    if (state is ListenerState) {
      switch (state) {
        case TakePhotoInitialListenerState():
          _originalImages.clear();
          _thumbImages.clear();
          _advisorFoodInfoList = null;
          break;
        case TakePhotoSuccessListenerState():
          _originalImages.insert(0, state.originalBytes);
          _thumbImages.insert(0, state.compressedBytes);
          break;
        case RemovePhotoListenerState():
          _originalImages.removeAt(state.index);
          _thumbImages.removeAt(state.index);
          break;
        case RecognizeImageLoadingListenerState():
          _isNextLoading = true;
          break;
        case RecognizeImageSuccessListenerState():
          _isNextLoading = false;
          _advisorFoodInfoList = state.data;
          _originalImages.clear();
          _thumbImages.clear();
          if (_advisorFoodInfoList?.isEmpty ?? true) {
            ShowWidgetUtil.showCustomModalBottomSheet(
              context: context,
              builder: (bsContext) {
                return NoResultsFoundBottomSheet(
                  height: 222.h,
                  onTapNegative: () {
                    Navigator.pop(bsContext);
                  },
                  onTapPositive: () {
                    _onTapSearch(context: context);
                  },
                );
              },
            );
          }
          break;
        case FoodLogLoadingListenerState():
          _visibleLoadingForLog = true;
          break;
        case FoodLogSuccessListenerState():
          _visibleLoadingForLog = false;
          context.showSnackbar(text: context.localization?.itemAddedToDiary);
          DashboardPage.navigate(
            context,
            page: 1,
            removeUntil: true,
          );
          break;
        case FoodLogFailureListenerState():
          _visibleLoadingForLog = false;
          context.showSnackbar(text: context.localization?.foodLogErrorMessage);
          break;
        case ShowIntroDialogListenerState():
          IntroDialog.show(
            context: context,
            onTapOk: (context) {
              Navigator.pop(context);
              _bloc.add(const DoIntroScreenCompletedEvent(fromDialog: true));
            },
          );
          break;
        case IntroDialogSeenListenerState():
          _seenIntroDialog = true;
          break;
      }
    }
  }

  void _onTapSearch({required BuildContext context}) {
    FoodSearchPage.navigate(context, needsReturn: false);
  }

  Future<void> _takePicture() async {
    final xFile = await _cameraKey.currentState?.getController()?.takePicture();
    _bloc.add(DoTakeImageEvent(file: xFile));
  }*/
}
