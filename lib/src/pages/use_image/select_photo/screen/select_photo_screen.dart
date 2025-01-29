part of '../select_photo_page.dart';

class _SelectPhotoScreen extends StatefulWidget {
  const _SelectPhotoScreen();

  @override
  State<_SelectPhotoScreen> createState() => _SelectPhotoScreenState();
}

class _SelectPhotoScreenState extends State<_SelectPhotoScreen>
    with PermissionManagerLifeCycleMixin
    implements PermissionCallback {

  // Permission Manager
  late final _permissionManagerUtility =
  PermissionManagerUtilityImpl(callback: this);

  late final _navigationDataProvider =
  SelectPhotoNavigationDataProvider.of(context);

  @override
  void onPermissionDenied(Permission permission) {}

  @override
  void onPermissionGranted(Permission permission) {
    context.read<SelectPhotoBloc>().add(
      DoPhotoPickerEvent(
        returnResult: _navigationDataProvider.returnResult,
        maxLimit: _navigationDataProvider.maxLimit,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _checkPermission();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SelectPhotoBloc, SelectPhotoState>(
      listener: _handleStateChanges,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: const SizedBox.shrink(),
      ),
    );
  }

  Future<void> _checkPermission() async {
    Permission permission = Permission.photos;
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      if (androidInfo.version.sdkInt <= 32) {
        permission = Permission.storage;
      }
    }
    if (!mounted) return;

    _permissionManagerUtility.requestPermissionWithSettingsDialog(
      context: context,
      permission: permission,
      title: context.localization.permission,
      description: context.localization.photosPermissionMessage,
      onTapCancelForSettings: (permission) {
        Navigator.pop(context);
      },
    );
  }

  void _handleStateChanges(BuildContext context, SelectPhotoState state) {
    if (state is ListenerState) {
      switch (state) {
        case PhotoPickerSuccessListenerState():
          final images = state.imagesBytes;
          if (state.returnResult) {
            Navigator.pop(context, images);
          } else {
            Navigator.pushReplacementNamed(context, Routes.takePhotoResult,
                arguments: images);
          }
          // _advisorFoodInfoList = null;
          // _isResultLoading = true;
          break;
        case PhotoPickerFailureListenerState():
          Navigator.pop(context);
          break;
        case RecognizeImageSuccessListenerState():
          // _isResultLoading = false;
          // _advisorFoodInfoList = state.data;
          // if (_advisorFoodInfoList?.isEmpty ?? true) {
          //   ShowWidgetUtil.showCustomModalBottomSheet(
          //     context: context,
          //     builder: (bsContext) {
          //       return NoResultsFoundBottomSheet(
          //         height: 222.h,
          //         onTapNegative: () {
          //           Navigator.pop(bsContext);
          //           _checkPermission();
          //         },
          //         onTapPositive: () {
          //           _onTapSearch(context: context);
          //         },
          //       );
          //     },
          //   );
          // }
          break;
        case RecognizeImageFailureListenerState():
          // context.showSnackbar(
          //   text: context.localization.galleryImageLimitMessage
          //       ?.format([widget.maxLimit.toString()]),
          // );
          break;
        case FoodLogLoadingListenerState():
          // _visibleLoadingForLog = true;
          break;
        case FoodLogSuccessListenerState():
          // _visibleLoadingForLog = false;
          // context.showSnackbar(text: context.localization.itemAddedToDiary);
          // DashboardPage.navigate(
          //   context,
          //   page: 1,
          //   removeUntil: true,
          // );
          break;
        case FoodLogFailureListenerState():
          // _visibleLoadingForLog = false;
          // context.showSnackbar(text: context.localization.foodLogErrorMessage);
          break;
      }
    }
  }
}
