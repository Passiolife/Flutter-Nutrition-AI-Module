import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../common/constant/app_padding.dart';
import '../../../common/extension/context_extension.dart';
import '../../../common/util/permission_manager_utility.dart';
import '../bloc/voice_logging_bloc.dart';
import '../widgets/voice_control_button_widget.dart';

class VoiceActionButtonsSection extends StatefulWidget {
  const VoiceActionButtonsSection({super.key});

  @override
  State<VoiceActionButtonsSection> createState() =>
      _VoiceActionButtonsSectionState();
}

class _VoiceActionButtonsSectionState extends State<VoiceActionButtonsSection> {
  // Listener for app lifecycle changes
  AppLifecycleListener? _lifecycleListener;

  // Instance of PermissionManagerUtility to handle permissions
  final PermissionManagerUtility _permissionManager =
      PermissionManagerUtility();

  late final VoiceLoggingBloc _bloc = context.read<VoiceLoggingBloc>();

  @override
  void initState() {
    // Create an AppLifecycleListener to listen for changes in the app lifecycle
    _lifecycleListener = AppLifecycleListener(
      // Callback function triggered on app lifecycle state change
      onStateChange: (state) {
        // Call permission manager to handle app lifecycle state change
        _permissionManager.didChangeAppLifecycleState(state);
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    _lifecycleListener?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VoiceLoggingBloc, VoiceLoggingState>(
      buildWhen: (_, state) {
        return state is VoiceLoggingInitial ||
            state is ListeningUpdateBuilderState ||
            state is ProcessingUpdateBuilderState ||
            state is RecognizeVoiceLogsSuccessState;
      },
      builder: (context, state) {
        if (state is ProcessingUpdateBuilderState || state is RecognizeVoiceLogsSuccessState) {
          return SizedBox.shrink();
        }
        bool isListening =
            (state is ListeningUpdateBuilderState) ? state.isListening : false;
        return Padding(
          padding: AppPadding.pb8 + EdgeInsets.only(bottom: context.bottomPadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: VoiceControlButtonWidget(
                  key: ValueKey<bool>(isListening),
                  isPlaying: isListening,
                  onTap: () {
                    if (isListening) {
                      isListening = !isListening;

                      // Stop playing
                      _bloc.add(const StopListeningEvent());
                    } else {
                      _checkPermission(context: context);
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future _checkPermission({required BuildContext context}) async {
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
              _bloc.add(const StartListeningEvent());
            }
          },
        );
      },
    );
  }
}
