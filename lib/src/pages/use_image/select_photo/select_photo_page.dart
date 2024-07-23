import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../common/constant/app_colors.dart';
import '../../../common/constant/app_text_styles.dart';
import '../../../common/models/advisor_food_info_log/advisor_food_info_log.dart';
import '../../../common/util/context_extension.dart';
import '../../../common/util/double_extensions.dart';
import '../../../common/util/permission_manager_utility.dart';
import '../../../common/util/snackbar_extension.dart';
import '../../../common/util/string_extensions.dart';
import '../../../common/widgets/food_item_row_widget.dart';
import '../../dashboard/dashboard_page.dart';
import 'bloc/select_photo_bloc.dart';
import 'widgets/widgets.dart';

class SelectPhotoPage extends StatefulWidget {
  const SelectPhotoPage({
    required this.returnResult,
    required this.maxLimit,
    super.key,
  });

  final bool returnResult;
  final int maxLimit;

  static Future navigate(BuildContext context,
      {bool returnResult = false, int maxLimit = 7}) async {
    return await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SelectPhotoPage(
          returnResult: returnResult,
          maxLimit: maxLimit,
        ),
      ),
    );
  }

  @override
  State<SelectPhotoPage> createState() => _SelectPhotoPageState();
}

class _SelectPhotoPageState extends State<SelectPhotoPage> {
  // Listener for app lifecycle changes
  AppLifecycleListener? _lifecycleListener;

  // Instance of PermissionManagerUtility to handle permissions
  final PermissionManagerUtility _permissionManager =
      PermissionManagerUtility();

  final _bloc = SelectPhotoBloc();

  List<XFile>? _images;
  List<AdvisorFoodInfoLog>? _advisorFoodInfoList;

  bool _isResultLoading = false;
  bool _visibleLoadingForLog = false;

  final ValueNotifier<double> _gridSize = ValueNotifier(0.35);

  @override
  void initState() {
    _initialize();
    super.initState();
  }

  @override
  void dispose() {
    _bloc.close();
    _lifecycleListener?.dispose();
    _images = null;
    _advisorFoodInfoList = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SelectPhotoBloc, SelectPhotoState>(
      bloc: _bloc,
      listener: (context, state) {
        _handleStateChanges(context, state);
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.gray50,
          resizeToAvoidBottomInset: false,
          body: Stack(
            children: [
              ValueListenableBuilder(
                  valueListenable: _gridSize,
                  builder: (context, value, child) {
                    return Positioned.fill(
                      top: context.topPadding.h,
                      bottom: context.height * value,
                      child: GridView.builder(
                        itemCount: _images?.length ?? 0,
                        shrinkWrap: true,
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 24.h,
                        ),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount:
                              _calculateCrossAxisCount(_images?.length ?? 0),
                          childAspectRatio: 127.r / 127.r,
                          crossAxisSpacing: 8.w,
                          mainAxisSpacing: 8.h,
                        ),
                        itemBuilder: (context, index) {
                          final file = _images?.elementAt(index);
                          return file?.path != null
                              ? Image.file(
                                  File(file!.path),
                                  fit: BoxFit.cover,
                                )
                              : const SizedBox.shrink();
                        },
                      ),
                    );
                  }),
              _isResultLoading
                  ? Positioned(
                      left: 0,
                      right: 0,
                      bottom: context.bottomPadding.h + (context.height * 0.1),
                      child: const GeneratingResultsWidget(),
                    )
                  : _advisorFoodInfoList != null
                      ? ResultWidget(
                          title: context.localization?.result ?? '',
                          subtitle: ((_advisorFoodInfoList?.length ?? 0) > 0)
                              ? context.localization?.resultDescription ?? ''
                              : '',
                          data: _advisorFoodInfoList,
                          clearVisible:
                              _advisorFoodInfoList?.hasSelectedItems() ?? false,
                          itemBuilder: (BuildContext context, int index) {
                            final data = _advisorFoodInfoList?.elementAt(index);

                            final advisorInfo = data?.advisorFoodInfoModel;

                            final foodDataInfo = advisorInfo?.foodDataInfo;
                            final iconId = foodDataInfo?.iconID ?? '';
                            final title = foodDataInfo?.foodName ?? '';
                            final calories =
                                foodDataInfo?.nutritionPreview.calories ?? 0;
                            final weightQuantity =
                                foodDataInfo?.nutritionPreview.weightQuantity ??
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
                                icon:
                                    SelectionIndicator(isSelected: isSelected),
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
                          onCalculateResultSize: (size) {
                            _gridSize.value = 1 - size;
                          },
                          onClear: () {
                            _bloc.add(ClearSelectionEvent(
                                data: _advisorFoodInfoList));
                          },
                          neutralButtonText: context.localization?.reselect,
                          onNeutralClick: () {
                            _checkPermission(
                                from: context.localization?.reselect);
                          },
                          negativeButtonText: context.localization?.cancel,
                          onNegativeClick: () {
                            Navigator.pop(context);
                          },
                          positiveButtonText: context.localization?.logSelected,
                          positiveButtonEnabled:
                              _advisorFoodInfoList?.hasSelectedItems() ?? false,
                          visibleLoadingForPositiveButton:
                              _visibleLoadingForLog,
                          onPositiveClick: () {
                            _bloc.add(
                                DoFoodLogEvent(data: _advisorFoodInfoList));
                          },
                        )
                      : const SizedBox.shrink(),
            ],
          ),
        );
      },
    );
  }

  void _initialize() {
    _lifecycleListener = AppLifecycleListener(
      // Callback function triggered on app lifecycle state change
      onStateChange: (state) {
        // Call permission manager to handle app lifecycle state change
        _permissionManager.didChangeAppLifecycleState(state);
      },
    );
    _checkPermission();
  }

  // Check camera permission
  Future _checkPermission({String? from}) async {
    Permission permission = Permission.photos;
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      if (androidInfo.version.sdkInt <= 32) {
        permission = Permission.storage;
      }
    }
    if (!mounted) return;
    await _permissionManager.request(
      context,
      permission,
      title: context.localization?.permission,
      message: context.localization?.photosPermissionMessage,
      onTapCancelForSettings: (contextPermission) {
        Navigator.pop(contextPermission);
        Navigator.pop(context);
      },
      onUpdateStatus: (Permission? permission) async {
        if (((await permission?.isGranted) ?? false) ||
            ((await permission?.isLimited) ?? false)) {
          _bloc.add(DoPhotoPickerEvent(
            from: from,
            returnResult: widget.returnResult,
            maxLimit: widget.maxLimit,
          ));
        }
      },
    );
  }

  void _handleStateChanges(BuildContext context, SelectPhotoState state) {
    if (state is ListenerState) {
      switch (state) {
        case PhotoPickerSuccessListenerState():
          _images = state.images;
          if (widget.returnResult) {
            Navigator.pop(context, _images);
          }
          _advisorFoodInfoList = null;
          _isResultLoading = true;
          break;
        case PhotoPickerFailureListenerState():
          Navigator.pop(context);
          break;
        case RecognizeImageSuccessListenerState():
          _isResultLoading = false;
          _advisorFoodInfoList = state.data;
          break;
        case RecognizeImageFailureListenerState():
          context.showSnackbar(
            text: context.localization?.galleryImageLimitMessage
                ?.format([widget.maxLimit.toString()]),
          );
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
      }
    }
  }

  int _calculateCrossAxisCount(int itemCount) {
    return 3;
    if (itemCount == 1) {
      return 1;
    } else if (itemCount == 2) {
      return 2;
    } else {
      return 2;
    }
  }
}
