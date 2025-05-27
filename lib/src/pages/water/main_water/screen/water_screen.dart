part of '../water_page.dart';

class _WaterScreen extends StatelessWidget {
  const _WaterScreen();

  @override
  Widget build(BuildContext context) {
    return BlocListener<WaterBloc, WaterState>(
      listener: _handleStateListener,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            const WaterAppBarSection(),
            24.verticalSpace,
            Expanded(
              child: Column(
                children: [
                  const WaterTabBarSection(),
                  const WaterBodySection(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleStateListener(BuildContext context, WaterState state) {
    if (state is FetchRecordsFailureState) {
      context.showSnackbar(text: state.error);
    } else if (state is QuickAddSuccessState) {
      context.showSnackbar(text: context.localization.waterRecorded);
    } else if (state is QuickAddFailureState) {
      context.showSnackbar(text: state.error);
    } else if (state is DeleteWaterFailureState) {
      context.showSnackbar(text: state.error);
    }
  }
}
