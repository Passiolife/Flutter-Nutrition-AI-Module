import 'dart:typed_data';

import '../../../../nutrition_ai_module.dart';
import '../advisor_food_info_log/advisor_food_info_log.dart';

class AdvisorChat {
  final bool isSentByMe;
  final String? message;
  final List<Uint8List>? images;
  final PassioAdvisorResponse? advisorResponse;
  final List<AdvisorFoodInfoLog>? advisorFoodInfoLogs;
  final bool isLoading;
  final bool isAnalyzingLoading;
  final bool isLogLoading;
  final bool isFromFetchIngredients;
  final bool isLogged;

  const AdvisorChat({
    required this.isSentByMe,
    this.isLoading = false,
    this.isAnalyzingLoading = false,
    this.isFromFetchIngredients = false,
    this.isLogLoading = false,
    this.isLogged = false,
    this.message,
    this.images,
    this.advisorResponse,
    this.advisorFoodInfoLogs,
  });

  AdvisorChat copyWith({
    bool? isSentByMe,
    String? message,
    List<Uint8List>? images,
    PassioAdvisorResponse? advisorResponse,
    List<AdvisorFoodInfoLog>? advisorFoodInfoLogs,
    bool? isLoading,
    bool? isAnalyzingLoading,
    bool? isLogLoading,
    bool? isFromFetchIngredients,
    bool? isLogged,
  }) {
    return AdvisorChat(
      isSentByMe: isSentByMe ?? this.isSentByMe,
      message: message ?? this.message,
      images: images ?? this.images,
      advisorResponse: advisorResponse ?? this.advisorResponse,
      advisorFoodInfoLogs: advisorFoodInfoLogs ?? this.advisorFoodInfoLogs,
      isLoading: isLoading ?? this.isLoading,
      isAnalyzingLoading: isAnalyzingLoading ?? this.isAnalyzingLoading,
      isLogLoading: isLogLoading ?? this.isLogLoading,
      isFromFetchIngredients:
          isFromFetchIngredients ?? this.isFromFetchIngredients,
      isLogged: isLogged ?? this.isLogged,
    );
  }
}
