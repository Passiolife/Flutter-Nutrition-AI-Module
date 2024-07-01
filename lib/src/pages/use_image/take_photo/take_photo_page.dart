import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../common/constant/app_constants.dart';
import '../../../common/models/advisor_food_info_log/advisor_food_info_log.dart';
import '../../../common/util/context_extension.dart';
import '../../../common/util/double_extensions.dart';
import '../../../common/util/snackbar_extension.dart';
import '../../dashboard/dashboard_page.dart';
import 'bloc/take_photo_bloc.dart';
import 'dialogs/intro_dialog.dart';
import 'widgets/widgets.dart';

class TakePhotoPage extends StatefulWidget {
  const TakePhotoPage({required this.returnResult, super.key});

  final bool returnResult;

  static Future navigate(BuildContext context,
      {bool returnResult = false}) async {
    return await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => TakePhotoPage(returnResult: returnResult)),
    );
  }

  @override
  State<TakePhotoPage> createState() => _TakePhotoPageState();
}

class _TakePhotoPageState extends State<TakePhotoPage> {
  final _bloc = TakePhotoBloc();

  // GlobalKey to uniquely identify the CameraWidget's state and access it
  final _cameraKey = GlobalKey<CameraWidgetState>();

  // Lists to store the original images and their thumbnails
  final List<Uint8List> _originalImages = [];
  final List<Uint8List> _thumbImages = [];

  // Maximum number of images allowed to be stored
  final _maxAllowedImages = 7;

  bool _isNextLoading = false;

  List<AdvisorFoodInfoLog>? _advisorFoodInfoList;

  bool _visibleLoadingForLog = false;

  bool _seenIntroDialog = false;

  @override
  void initState() {
    _bloc.add(const DoCheckIntroScreenEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
      bloc: _bloc,
      listener: (context, state) {
        _handleStateChanges(context, state);
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.gray50,
          resizeToAvoidBottomInset: false,
          body: _seenIntroDialog
              ? Stack(
                  fit: StackFit.expand,
                  children: [
                    CameraWidget(
                      key: _cameraKey,
                      resolution: ResolutionPreset.veryHigh,
                    ),
                    ActionButtonsWidget(
                      onNegativeTap: () {
                        Navigator.pop(context);
                      },
                      captureEnabled:
                          _originalImages.length < _maxAllowedImages,
                      onCapture: () {
                        _takePicture();
                      },
                      positiveEnabled: _thumbImages.isNotEmpty,
                      visibleLoadingForPositiveButton: _isNextLoading,
                      onPositiveTap: () {
                        if (widget.returnResult) {
                          Navigator.pop(context, _originalImages);
                          return;
                        }
                        _bloc.add(DoNextEvent(images: _originalImages));
                      },
                    ),
                    CarouselSliderWidget(
                      images: _thumbImages,
                      onDelete: (index) {
                        _bloc.add(DoRemoveImageEvent(index: index));
                      },
                    ),
                    Positioned(
                      top: 0,
                      left: 24.w,
                      right: 24.w,
                      bottom: 88.h,
                      child: SvgPicture.asset(
                        AppImages.icScanFrame,
                        width: double.infinity,
                        height: 380.h,
                      ),
                    ),
                    _advisorFoodInfoList != null
                        ? ResultWidget(
                            title: context.localization?.result ?? '',
                            subtitle: ((_advisorFoodInfoList?.length ?? 0) > 0)
                                ? context.localization?.resultDescription ?? ''
                                : '',
                            data: _advisorFoodInfoList,
                            clearVisible:
                                _advisorFoodInfoList?.hasSelectedItems() ??
                                    false,
                            itemBuilder: (BuildContext context, int index) {
                              final data =
                                  _advisorFoodInfoList?.elementAt(index);

                              final advisorInfo = data?.advisorFoodInfoModel;

                              final foodDataInfo = advisorInfo?.foodDataInfo;
                              final iconId = foodDataInfo?.iconID ?? '';
                              final title = foodDataInfo?.foodName ?? '';
                              final calories =
                                  foodDataInfo?.nutritionPreview.calories ?? 0;
                              final weightQuantity = foodDataInfo
                                      ?.nutritionPreview.weightQuantity ??
                                  0;
                              final caloriesPerGram = calories / weightQuantity;
                              final weightGrams = advisorInfo?.weightGrams ?? 0;
                              final caloriesForPortionSize =
                                  caloriesPerGram * weightGrams;
                              final portionSize = advisorInfo?.portionSize ??
                                  '${weightGrams.format()} ${context.localization?.g}';
                              final subtitle =
                                  '$portionSize | ${caloriesForPortionSize.format()} ${context.localization?.cal}';

                              final isSelected = data?.isSelected ?? false;

                              return FoodItemRowWidget(
                                iconId: iconId,
                                title: title,
                                subtitle: subtitle,
                                isAddVisible: false,
                                padding: EdgeInsets.zero,
                                suffix: IconButton(
                                  onPressed: () {
                                    if (data != null) {
                                      _bloc.add(UpdateSelectionEvent(
                                          data: _advisorFoodInfoList,
                                          index: index));
                                    }
                                  },
                                  icon: SelectionIndicator(
                                      isSelected: isSelected),
                                ),
                                onTap: () {
                                  if (data != null) {
                                    _bloc.add(UpdateSelectionEvent(
                                        data: _advisorFoodInfoList,
                                        index: index));
                                  }
                                },
                              );
                            },
                            emptyBuilder: () {
                              return Center(
                                child: Text(
                                  context.localization?.noResultsFound ?? '',
                                  style: AppTextStyle.textSm,
                                ),
                              );
                            },
                            onClear: () {
                              _bloc.add(ClearSelectionEvent(
                                  data: _advisorFoodInfoList));
                            },
                            neutralButtonText: context.localization?.retake,
                            onNeutralClick: () {
                              _bloc.add(const InitialEvent());
                            },
                            negativeButtonText: context.localization?.cancel,
                            onNegativeClick: () {
                              Navigator.pop(context);
                            },
                            positiveButtonText:
                                context.localization?.logSelected,
                            positiveButtonEnabled:
                                _advisorFoodInfoList?.hasSelectedItems() ??
                                    false,
                            visibleLoadingForPositiveButton:
                                _visibleLoadingForLog,
                            onPositiveClick: () {
                              _bloc.add(
                                  DoFoodLogEvent(data: _advisorFoodInfoList));
                            },
                          )
                        : const SizedBox.shrink(),
                  ],
                )
              : const SizedBox.shrink(),
        );
      },
    );
  }

  @override
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

  Future<void> _takePicture() async {
    final xFile = await _cameraKey.currentState?.getController()?.takePicture();
    _bloc.add(DoTakeImageEvent(file: xFile));
  }
}
