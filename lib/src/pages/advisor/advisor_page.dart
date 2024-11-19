import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../common/constant/app_constants.dart';
import '../../common/models/advisor_chat/advisor_chat.dart';
import '../../common/util/context_extension.dart';
import '../../common/widgets/adaptive_loader.dart';
import '../../common/widgets/custom_app_bar_widget.dart';
import '../dashboard/bloc/dashboard_bloc.dart';
import '../use_image/select_photo/select_photo_page.dart';
import '../use_image/take_photo/take_photo_page.dart';
import 'bloc/advisor_bloc.dart';
import 'widgets/widgets.dart';

class AdvisorPage extends StatefulWidget {
  const AdvisorPage({super.key});

  static Future navigate(BuildContext context) async {
    return await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: BlocProvider.of<DashboardBloc>(context),
          child: const AdvisorPage(),
        ),
      ),
    );
  }

  @override
  State<AdvisorPage> createState() => _AdvisorPageState();
}

class _AdvisorPageState extends State<AdvisorPage> {
  final _bloc = AdvisorBloc();

  bool _isAdvisorReady = false;
  String? _configureError;

  List<AdvisorChat>? _chatList;

  bool _visibleLoadingForSendButton = false;

  ValueKey _chatKey = const ValueKey(null);
  final _chatActionKey = GlobalKey<ChatActionWidgetState>();

  @override
  void initState() {
    // SchedulerBinding.instance.addPostFrameCallback((_){
    //   IntroDialog.show(context: context);
    // });
    _bloc.add(const DoInitializationEvent());
    super.initState();
  }

  @override
  void dispose() {
    _chatList = null;
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdvisorBloc, AdvisorState>(
      bloc: _bloc,
      listener: (context, state) {
        _handleStateChanges(context: context, state: state);
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.gray50,
          body: Column(
            children: [
              CustomAppBarWidget(title: context.localization?.aiAdvisor),
              if (!_isAdvisorReady)
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      (_configureError == null ||
                              (_configureError?.isEmpty ?? false))
                          ? const AdaptiveLoader()
                          : const SizedBox.shrink(),
                      Text(
                        _configureError ??
                            context.localization?.initializingAdvisor ??
                            '',
                        style: AppTextStyle.textBase,
                      ),
                    ],
                  ),
                ),
              if (_isAdvisorReady)
                ChatWidget(
                  key: _chatKey,
                  list: _chatList,
                  onTapFindFoods: (index, advisorChat) {
                    _bloc.add(DoFetchIngredientsEvent(
                        index: index, advisorChat: advisorChat));
                  },
                  onChangeSelection:
                      (index, itemIndex, advisorChat, advisorFoodInfoLog) {
                    _bloc.add(DoChangeSelectionEvent(
                      index: index,
                      itemIndex: itemIndex,
                      advisorChat: advisorChat,
                      advisorFoodInfoLog: advisorFoodInfoLog,
                    ));
                  },
                  onLog: (index, advisorChat) {
                    _bloc.add(DoFoodLogEvent(index: index, data: advisorChat));
                  },
                ),
              if (_isAdvisorReady)
                ChatActionWidget(
                  key: _chatActionKey,
                  onTapCamera: () async {
                    final images = await TakePhotoPage.navigate(
                      context,
                      returnResult: true,
                    );
                    if (images != null && images is List<Uint8List>) {
                      _bloc.add(DoSendImageEvent(images: images));
                      _chatActionKey.currentState?.setVisibleAddActions(false);
                    }
                  },
                  onTapGallery: () async {
                    final images = await SelectPhotoPage.navigate(
                      context,
                      returnResult: true,
                    );
                    if (images != null && images is List<dynamic>) {
                      _bloc.add(DoSendImageEvent(images: images));
                      _chatActionKey.currentState?.setVisibleAddActions(false);
                    }
                  },
                  onTapSend: (value) {
                    _bloc.add(DoSendMessageEvent(message: value));
                  },
                  visibleLoadingForSendButton: _visibleLoadingForSendButton,
                ),
              (context.bottomPadding + 8.h).verticalSpace,
            ],
          ),
        );
      },
    );
  }

  void _handleStateChanges({
    required BuildContext context,
    required AdvisorState state,
  }) {
    if (state is ListenerState) {
      switch (state) {
        case ConfigureErrorListenerState():
          _configureError = state.message;
          break;
        case InitializationErrorListenerState():
          _configureError = state.message;
          break;
        case InitializationSuccessListenerState():
          _isAdvisorReady = true;
          _chatList = state.chats;
        case SendLoadingListenerState():
          _chatList = state.chats;
          _chatKey = ValueKey(_chatList?.lastOrNull);
          _visibleLoadingForSendButton = true;
          break;
        case SendSuccessListenerState():
          _chatList = state.chats;
          _chatKey = ValueKey(_chatList?.lastOrNull);
          _visibleLoadingForSendButton = false;
          break;
        case ChangeSelectionListenerState():
          _chatList = state.chats;
          break;
        case FoodLogLoadingListenerState():
          _chatList = state.chats;
          break;
        case FoodLogSuccessListenerState():
          _chatList = state.chats;
          break;
      }
    }
  }
}
