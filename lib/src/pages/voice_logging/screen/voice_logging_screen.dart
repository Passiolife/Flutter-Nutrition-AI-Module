part of '../voice_logging_page.dart';

class _VoiceLoggingScreen extends StatefulWidget {
  const _VoiceLoggingScreen();

  @override
  State<_VoiceLoggingScreen> createState() => _VoiceLoggingScreenState();
}

class _VoiceLoggingScreenState extends State<_VoiceLoggingScreen> {
  VoiceLoggingBloc? get _bloc =>
      context.mounted ? context.read<VoiceLoggingBloc>() : null;

  @override
  void dispose() {
    _bloc?.add(const DoCancelEvent());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<VoiceLoggingBloc, VoiceLoggingState>(
      listener: _handleStateChanges,
      child: Scaffold(
        backgroundColor: AppColors.gray50,
        body: Column(
          children: [
            CustomAppBarWidget(title: context.localization.voiceLogging),
            Expanded(
              child: Column(
                children: [
                  40.verticalSpace,
                  const RecognizedTextSection(),
                  const VoiceProcessingSection(),
                  const VoiceResultSection(),
                  const VoiceActionButtonsSection(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleStateChanges(BuildContext context, VoiceLoggingState state) {
    if (state is ListenerState) {
      switch (state) {
        case ErrorListenerState():
          // Handle error state
          context.showSnackbar(text: state.error);
          break;
        case VoiceLogsRecognitionErrorListenerState():
          ShowWidgetUtil.showCustomModalBottomSheet(
            context: context,
            builder: (bsContext) {
              return NoResultsFoundBottomSheet(
                height: 222.h,
                onTapNegative: () {
                  Navigator.pop(bsContext);
                  _bloc?.add(const TryAgainEvent());
                },
                onTapPositive: () {
                  _onTapSearch(context: context);
                },
              );
            },
          );
          break;
        case FoodLogSuccessListenerState():
          context.showSnackbar(text: context.localization.itemAddedToDiary);
          DashboardPage.navigate(
            context,
            page: 1,
            removeUntil: true,
          );
          break;
        case FoodLogFailureListenerState():
          context.showSnackbar(text: context.localization.foodLogErrorMessage);
          break;
      }
    }
  }

  void _onTapSearch({required BuildContext context}) {
    FoodSearchPage.navigate(context, needsReturn: false);
  }
}
