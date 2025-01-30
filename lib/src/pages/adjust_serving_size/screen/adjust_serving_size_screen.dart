part of '../adjust_serving_size_page.dart';

class _AdjustServingSizeScreen extends StatefulWidget {
  const _AdjustServingSizeScreen({super.key});

  @override
  State<_AdjustServingSizeScreen> createState() =>
      _AdjustServingSizeScreenState();
}

class _AdjustServingSizeScreenState extends State<_AdjustServingSizeScreen> {
  late final AdjustServingSizeNavigationDataProvider _navigationData =
      AdjustServingSizeNavigationDataProvider.of(context);

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      context.read<AdjustServingSizeBloc>().add(ProcessEvent(
            foodRecord: _navigationData.foodRecord,
            index: _navigationData.index,
            image: _navigationData.image,
          ));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: AppColors.transparent,
        child: Wrap(
          children: [
            Container(
              decoration: AppShadows.base,
              padding: AppPadding.pa16,
              margin: AppPadding.pa16,
              child: Column(
                children: [
                  Text(
                    context.localization.adjustServingSize ?? '',
                    style: AppTextStyle.textXl.addAll([
                      AppTextStyle.textXl.leading7,
                      AppTextStyle.bold,
                    ]),
                  ),
                  16.verticalSpace,
                  const FoodDetailsSection(),
                  16.verticalSpace,
                  const ServingSizeSection(),
                  16.verticalSpace,
                  ActionButtonsWidget(
                    onCancel: () {
                      Navigator.pop(context);
                    },
                    onDone: () {
                      final foodRecord = context.read<AdjustServingSizeBloc>().foodRecord;
                      Navigator.pop(context, foodRecord);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
