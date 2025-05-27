part of '../weight_page.dart';

class _WeightScreen extends StatelessWidget {
  const _WeightScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<WeightBloc, WeightState>(
      listener: _handleStateListener,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            const WeightAppBarSection(),
            24.verticalSpace,
            Expanded(
              child: Column(
                children: [
                  const WeightTabBarSection(),
                  // const WaterBodySection(),
                ],
              ),
            ),
          ],
        ),
      ),
    );

  }

  void _handleStateListener(BuildContext context, WeightState state) {
    // if (state is FetchRecordsFailureState) {
    //   context.showSnackbar(text: state.error);
    // } else if (state is QuickAddSuccessState) {
    //   context.showSnackbar(text: context.localization.waterRecorded);
    // } else if (state is QuickAddFailureState) {
    //   context.showSnackbar(text: state.error);
    // } else if (state is DeleteWaterFailureState) {
    //   context.showSnackbar(text: state.error);
    // }
  }
}