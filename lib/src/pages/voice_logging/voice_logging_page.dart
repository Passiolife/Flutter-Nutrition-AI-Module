import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../common/constant/app_constants.dart';
import '../../common/models/voice_log/voice_log.dart';
import '../../common/util/context_extension.dart';
import '../../common/util/permission_manager_utility.dart';
import '../../common/util/snackbar_extension.dart';
import '../../common/widgets/custom_app_bar_widget.dart';
import '../dashboard/bloc/dashboard_bloc.dart';
import '../dashboard/dashboard_page.dart';
import '../food_search/food_search_page.dart';
import 'bloc/voice_logging_bloc.dart';
import 'widgets/widgets.dart';

class VoiceLoggingPage extends StatefulWidget {
  const VoiceLoggingPage({required this.context, super.key});

  final BuildContext context;

  static Future navigate(BuildContext context) async {
    return await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: BlocProvider.of<DashboardBloc>(context),
          child: VoiceLoggingPage(context: context),
        ),
      ),
    );
  }

  @override
  State<VoiceLoggingPage> createState() => _VoiceLoggingPageState();
}

class _VoiceLoggingPageState extends State<VoiceLoggingPage> {
  bool _isListening = false;
  bool _isGeneratingResults = false;
  bool _visibleResult = false;
  bool _visibleLoadingForLog = false;

  final _bloc = VoiceLoggingBloc();

  String _recognizedWords = '';

  List<VoiceLog>? _voiceLogs;

  // Listener for app lifecycle changes
  AppLifecycleListener? _lifecycleListener;

  // Instance of PermissionManagerUtility to handle permissions
  final PermissionManagerUtility _permissionManager =
      PermissionManagerUtility();

  @override
  void initState() {
    _initialize();
    super.initState();
  }

  @override
  void dispose() {
    _bloc.add(const DoCancelEvent());
    _bloc.close();
    _voiceLogs = null;
    _lifecycleListener?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<VoiceLoggingBloc, VoiceLoggingState>(
      bloc: _bloc,
      listener: (context, state) {
        _handleStateChanges(context, state);
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.gray50,
          resizeToAvoidBottomInset: false,
          body: Column(
            children: [
              CustomAppBarWidget(
                title: context.localization?.voiceLogging,
              ),
              Expanded(
                child: Column(
                  children: [
                    40.verticalSpace,
                    _recognizedWords.isNotEmpty
                        ? RecognizedTextWidget(
                            recognizedWords: _recognizedWords)
                        : const SizedBox.shrink(),
                    Expanded(
                      child: _isListening
                          ? Image.asset(
                              AppImages.wave,
                              width: context.width,
                              height: 100.h,
                              fit: BoxFit.cover,
                            )
                          : _isGeneratingResults
                              ? const GeneratingResultsWidget()
                              : _visibleResult
                                  ? ResultWidget(
                                      title: context.localization?.result ?? '',
                                      subtitle: context.localization
                                              ?.resultDescription ??
                                          '',
                                      voiceLogs: _voiceLogs,
                                      onChangeSelection:
                                          (int index, VoiceLog data) {
                                        _bloc.add(UpdateSelectionEvent(
                                          index: index,
                                          voiceLog: data,
                                        ));
                                      },
                                      clearVisible:
                                          _voiceLogs?.hasSelectedItems() ??
                                              false,
                                      onClear: () {
                                        _bloc.add(const ClearSelectionEvent());
                                      },
                                      onTapSearch: () {
                                        FoodSearchPage.navigate(context,
                                            needsReturn: false);
                                      },
                                      onTryAgain: () {
                                        _bloc.add(const StartListeningEvent());
                                      },
                                      logButtonEnabled:
                                          _voiceLogs?.hasSelectedItems() ??
                                              false,
                                      visibleLoadingForLog:
                                          _visibleLoadingForLog,
                                      onLogSelected: () {
                                        _bloc.add(const DoFoodLogEvent());
                                      },
                                    )
                                  : const TutorialWidget(),
                    ),
                    !_isGeneratingResults && !_visibleResult
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 250),
                                child: ListeningButton(
                                  key: ValueKey<bool>(_isListening),
                                  isPlaying: _isListening,
                                  onTap: () {
                                    if (_isListening) {
                                      _isListening = !_isListening;

                                      // Stop playing
                                      _bloc.add(const StopListeningEvent());
                                    } else {
                                      _checkPermission(
                                        () {
                                          _isListening = !_isListening;
                                          _bloc
                                              .add(const StartListeningEvent());
                                        },
                                      );
                                    }
                                  },
                                ),
                              ),
                            ],
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
              ),
              !_visibleResult
                  ? (context.bottomPadding + 16.h).verticalSpace
                  : const SizedBox.shrink(),
            ],
          ),
        );
      },
    );
  }

  void _initialize() {
    // Create an AppLifecycleListener to listen for changes in the app lifecycle
    _lifecycleListener = AppLifecycleListener(
      // Callback function triggered on app lifecycle state change
      onStateChange: (state) {
        // Call permission manager to handle app lifecycle state change
        _permissionManager.didChangeAppLifecycleState(state);
      },
    );
  }

  // Check camera permission
  Future _checkPermission(VoidCallback? onUpdateStatus) async {
    await _permissionManager.request(
      context,
      Permission.microphone,
      title: context.localization?.permission,
      message: context.localization?.microphonePermissionMessage,
      onTapCancelForSettings: (contextPermission) {
        Navigator.pop(contextPermission);
      },
      onUpdateStatus: (permission) async {
        await _permissionManager.request(
          context,
          Permission.speech,
          title: context.localization?.permission,
          message: context.localization?.speechRecognitionPermissionMessage,
          onTapCancelForSettings: (contextPermission) {
            Navigator.pop(contextPermission);
          },
          onUpdateStatus: (permission) async {
            if ((await permission?.isGranted) ?? false) {
              onUpdateStatus?.call();
            }
          },
        );
      },
    );
  }

  void _handleStateChanges(BuildContext context, VoiceLoggingState state) {
    if (state is ListenerState) {
      switch (state) {
        case ErrorListenerState():
          // Handle error state
          context.showSnackbar(text: state.error);
          break;
        case ListenerStateStarted():
          // Handle listener started state
          _isListening = true;
          _isGeneratingResults = false;
          _visibleResult = false;
          _voiceLogs = null;
          _visibleLoadingForLog = false;
          _recognizedWords = '';
          break;
        case RecognizeListenerState():
          // Handle recognizing state
          _recognizedWords = state.words;
          break;
        case ListenerStateStopped():
          // Handle listener stopped state
          _isListening = false;
          _isGeneratingResults = _recognizedWords.isNotEmpty;
          _visibleResult = false;
          if (_isGeneratingResults) {
            _bloc.add(RecognizeSpeechRemoteEvent(text: _recognizedWords));
          }
          break;
        case VoiceLogsRecognitionSuccessListenerState():
          // Handle recognition of voice logs state
          _isListening = false;
          _isGeneratingResults = false;
          _visibleResult = true;
          _voiceLogs = state.data;
          break;
        case VoiceLogsRecognitionErrorListenerState():
          _recognizedWords = '';
          context.showSnackbar(
              text: context.localization?.recognitionErrorMessage);
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
        case FoodLogLoadingListenerState():
          _visibleLoadingForLog = true;
          break;
        case FoodLogFailureListenerState():
          context.showSnackbar(text: context.localization?.foodLogErrorMessage);
          break;
      }
    }
  }
}
