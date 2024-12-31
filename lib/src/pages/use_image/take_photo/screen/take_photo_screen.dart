part of '../take_photo_page.dart';

class _TakePhotoScreen extends StatefulWidget {
  const _TakePhotoScreen({super.key});

  @override
  State<_TakePhotoScreen> createState() => _TakePhotoScreenState();
}

class _TakePhotoScreenState extends State<_TakePhotoScreen> {
  bool _seenIntroDialog = true;

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      ShowWidgetUtil.showCustomModalBottomSheet(
        context: context,
        isDismissible: false,
        isScrollControlled: true,
        builder: (bsContext) {
          return ResultSection();
        },
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TakePhotoBloc, TakePhotoState>(
      listener: (context, state) {
        // _handleStateChanges(context, state);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: _seenIntroDialog
            ? Stack(
                children: [
                  const CameraSection(),
                  const CameraFrameSection(),
                  const CapturedImagesSection(),
                ],
              )
            : const SizedBox.shrink(),
      ),
    );
  }
}
