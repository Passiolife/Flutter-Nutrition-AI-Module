part of '../take_photo_result_page.dart';

class _TakePhotoResultScreen extends StatefulWidget {
  const _TakePhotoResultScreen({super.key});

  @override
  State<_TakePhotoResultScreen> createState() => _TakePhotoResultScreenState();
}

class _TakePhotoResultScreenState extends State<_TakePhotoResultScreen> {

  TakePhotoResultBloc? get _bloc => mounted ? context.read<TakePhotoResultBloc>() : null;

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
    return Scaffold(
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
          const BarcodeMissingDataWidget(),
          const FoodItemsListSection(),
          const ActionButtonsSection(),
          context.bottomPadding.verticalSpace,
        ],
      ),
    );
  }
}
