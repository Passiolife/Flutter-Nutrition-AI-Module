import 'dart:async';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../nutrition_ai_module.dart';
import '../../../common/models/advisor_chat/advisor_chat.dart';
import '../../../common/models/advisor_food_info_log/advisor_food_info_log.dart';

part 'advisor_event.dart';
part 'advisor_state.dart';

class AdvisorBloc extends Bloc<AdvisorEvent, AdvisorState> {
  /// [_connector] use to perform operations.
  PassioConnector get _connector =>
      NutritionAIModule.instance.configuration.connector;

  final List<AdvisorChat> _chats = [];

  final String _welcomeMessage = '''
Welcome! I am your AI Nutrition Advisor!

### You can ask me things like:
- How many calories are in a yogurt?
- Create me a recipe for dinner?
- How can I adjust my diet for heart health?

Let's chat!
''';

  AdvisorBloc() : super(const AdvisorInitial()) {
    on<DoInitializationEvent>(_handleDoInitializationEvent);
    on<DoSendMessageEvent>(_handleDoSendMessageEvent);
    on<DoFetchIngredientsEvent>(_handleDoFetchIngredientsEvent);
    on<DoSendImageEvent>(_handleDoSendImageEvent);
    on<DoChangeSelectionEvent>(_handleDoChangeSelectionEvent);
    on<DoFoodLogEvent>(_handleDoFoodLogEvent);
  }

  Future<void> _handleDoInitializationEvent(
      DoInitializationEvent event, Emitter<AdvisorState> emit) async {

    await NutritionAI.instance.shutDownPassioSDK();
    const passioConfig =
    PassioConfiguration('jNF7sKOufr1K0vYBNe7HShIgmv4dkJCYuvvro7pW', debugMode: 1);
    await NutritionAI.instance.configureSDK(passioConfig);

    final result = await NutritionAdvisor.instance.initConversation();
    switch (result) {
      case Error():
        emit(InitializationErrorListenerState(result.message));
        emit(const InitializationErrorBuilderState());
        break;
      case Success():
        final advisorChat = AdvisorChat(
          isSentByMe: false,
          advisorResponse: PassioAdvisorResponse(
            markupContent: _welcomeMessage,
            messageId: '',
            rawContent: '',
            threadId: '',
          ),
        );
        _chats.add(advisorChat);
        emit(InitializationSuccessListenerState(chats: _chats));
        emit(const InitializationSuccessBuilderState());
        break;
    }
  }

  Future<void> _handleDoSendMessageEvent(
      DoSendMessageEvent event, Emitter<AdvisorState> emit) async {
    final sentAdvisorChat = AdvisorChat(
      isSentByMe: true,
      message: event.message,
    );
    const loadingAdvisorChat = AdvisorChat(
      isSentByMe: false,
      isLoading: true,
    );

    _chats.add(sentAdvisorChat);
    _chats.add(loadingAdvisorChat);

    emit(SendLoadingListenerState(chats: _chats));
    emit(const SendLoadingBuilderState());

    PassioResult<PassioAdvisorResponse> result = await NutritionAdvisor.instance
        .sendMessage(sentAdvisorChat.message ?? '');

    switch (result) {
      case Error():
        final advisorChat =
            AdvisorChat(isSentByMe: false, message: result.message);
        _chats.removeLast();
        _chats.add(advisorChat);
        emit(SendSuccessListenerState(chats: _chats));
        emit(const SendSuccessBuilderState());
        break;
      case Success<PassioAdvisorResponse>():
        final advisorChat =
            AdvisorChat(isSentByMe: false, advisorResponse: result.value);
        _chats.removeLast();
        _chats.add(advisorChat);
        emit(SendSuccessListenerState(chats: _chats));
        emit(const SendSuccessBuilderState());
        break;
    }
  }

  FutureOr<void> _handleDoSendImageEvent(
      DoSendImageEvent event, Emitter<AdvisorState> emit) async {
    List<Uint8List>? images;
    if (event.images is List<Uint8List>?) {
      images = event.images as List<Uint8List>;
    } else if (event.images is List<XFile>?) {
      final imageFiles = event.images as List<XFile>;
      images =
          await Future.wait(imageFiles.map((e) => e.readAsBytes()).toList());
    }

    final sentAdvisorChat = AdvisorChat(
      isSentByMe: true,
      images: images,
    );
    const loadingAdvisorChat = AdvisorChat(
      isSentByMe: false,
      isAnalyzingLoading: true,
    );

    _chats.add(sentAdvisorChat);
    _chats.add(loadingAdvisorChat);

    emit(SendLoadingListenerState(chats: _chats));
    emit(const SendLoadingBuilderState());

    List<PassioResult<PassioAdvisorResponse>> result = await Future.wait(
        sentAdvisorChat.images!
            .map((e) => NutritionAdvisor.instance.sendImage(e)));

    List<PassioAdvisorResponse?> mappedResponses = result
        .map((e) =>
            e is Success ? (e as Success).value as PassioAdvisorResponse : null)
        .toList();

    final advisorResponse =
        mappedResponses.whereType<PassioAdvisorResponse>().toList();

    final advisorFoodInfoList = advisorResponse
        .expand<PassioAdvisorFoodInfo>((e) => e.extractedIngredients ?? [])
        .toList();
    final advisorFoodInfoLogList =
        advisorFoodInfoList.toAdvisorFoodInfoLogList();

    final advisorChat = AdvisorChat(
        isSentByMe: false, advisorFoodInfoLogs: advisorFoodInfoLogList);
    _chats.removeLast();
    _chats.add(advisorChat);
    emit(SendSuccessListenerState(chats: _chats));
    emit(const SendSuccessBuilderState());
  }

  FutureOr<void> _handleDoFetchIngredientsEvent(
      DoFetchIngredientsEvent event, Emitter<AdvisorState> emit) async {
    final advisorResponse = event.advisorChat?.advisorResponse;
    if (advisorResponse == null) return;
    const loadingAdvisorChat = AdvisorChat(
      isSentByMe: false,
      isLoading: true,
    );

    _chats.add(loadingAdvisorChat);

    emit(SendLoadingListenerState(chats: _chats));
    emit(const SendLoadingBuilderState());

    final result =
        await NutritionAdvisor.instance.fetchIngredients(advisorResponse);
    switch (result) {
      case Error():
        final advisorChat =
            AdvisorChat(isSentByMe: false, message: result.message);
        _chats.removeLast();
        _chats.add(advisorChat);
        emit(SendSuccessListenerState(chats: _chats));
        emit(const SendSuccessBuilderState());
        break;
      case Success<PassioAdvisorResponse>():
        final advisorFoodInfoLogList =
            result.value.extractedIngredients?.toAdvisorFoodInfoLogList();
        final advisorChat = AdvisorChat(
          isSentByMe: false,
          advisorFoodInfoLogs: advisorFoodInfoLogList,
          isFromFetchIngredients: true,
        );
        _chats.removeLast();
        _chats.add(advisorChat);
        emit(SendSuccessListenerState(chats: _chats));
        emit(const SendSuccessBuilderState());
        break;
    }
  }

  FutureOr<void> _handleDoChangeSelectionEvent(
      DoChangeSelectionEvent event, Emitter<AdvisorState> emit) async {
    _chats.elementAt(event.index).advisorFoodInfoLogs?[event.itemIndex] = event
        .advisorFoodInfoLog
        .setSelection(!event.advisorFoodInfoLog.isSelected);
    emit(ChangeSelectionListenerState(chats: _chats));
    emit(const ChangeSelectionBuilderState());
  }

  Future<void> _handleDoFoodLogEvent(
      DoFoodLogEvent event, Emitter<AdvisorState> emit) async {
    _chats[event.index] =
        _chats.elementAt(event.index).copyWith(isLogLoading: true);

    emit(FoodLogLoadingListenerState(chats: _chats));
    emit(const FoodLogLoadingBuilderState());

    final updateLogFlag = _chats
        .elementAt(event.index)
        .advisorFoodInfoLogs
        ?.map((e) => e.copyWith(isLogged: e.isSelected))
        .toList();

    _chats[event.index] = _chats
        .elementAt(event.index)
        .copyWith(advisorFoodInfoLogs: updateLogFlag);
    final selectedLogs = updateLogFlag?.where((e) => e.isSelected).toList();

    if (selectedLogs == null || selectedLogs.isEmpty) {
      _chats[event.index] =
          _chats.elementAt(event.index).copyWith(isLogLoading: false);
      _chats[event.index] =
          _chats.elementAt(event.index).copyWith(isLogged: true);
      emit(FoodLogSuccessListenerState(chats: _chats));
      emit(const FoodLogSuccessBuilderState());
      return;
    }

    try {
      List<FoodRecord?> foodRecords =
          await Future.wait(selectedLogs.map((element) async {
        final advisorFoodInfo = element.advisorFoodInfoModel;
        final foodDataInfo = advisorFoodInfo?.foodDataInfo;
        if (foodDataInfo == null) return null;

        try {
          final nutritionPreview = foodDataInfo.nutritionPreview;
          final foodItem = await NutritionAI.instance.fetchFoodItemForDataInfo(
            foodDataInfo,
            servingQuantity: nutritionPreview.servingQuantity,
            servingUnit: nutritionPreview.servingUnit,
          );
          if (foodItem == null) return null;

          final foodRecord = FoodRecord.fromPassioFoodItem(foodItem);

          return foodRecord;
        } catch (e) {
          return null;
        }
      }).toList());

      // Remove any null values resulting from failed fetch operations
      foodRecords = foodRecords.where((record) => record != null).toList();

      // Update records concurrently using Future.wait
      await Future.wait(foodRecords.map((foodRecord) async {
        try {
          await _connector.updateRecord(foodRecord: foodRecord!, isNew: true);
        } catch (e) {
          _chats[event.index] =
              _chats.elementAt(event.index).copyWith(isLogLoading: false);
          _chats[event.index] =
              _chats.elementAt(event.index).copyWith(isLogged: true);
          emit(FoodLogSuccessListenerState(chats: _chats));
          emit(const FoodLogSuccessBuilderState());
        }
      }));
      _chats[event.index] =
          _chats.elementAt(event.index).copyWith(isLogLoading: false);
      _chats[event.index] =
          _chats.elementAt(event.index).copyWith(isLogged: true);
      emit(FoodLogSuccessListenerState(chats: _chats));
      emit(const FoodLogSuccessBuilderState());
    } catch (e) {
      _chats[event.index] =
          _chats.elementAt(event.index).copyWith(isLogLoading: false);
      _chats[event.index] =
          _chats.elementAt(event.index).copyWith(isLogged: true);
      emit(FoodLogSuccessListenerState(chats: _chats));
      emit(const FoodLogSuccessBuilderState());
    }
  }
}
