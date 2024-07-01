import 'package:nutrition_ai/nutrition_ai.dart';

class AdvisorFoodInfoLog {
  final PassioAdvisorFoodInfo? advisorFoodInfoModel;
  final bool isSelected;
  final bool? isLogged;

  const AdvisorFoodInfoLog({
    this.advisorFoodInfoModel,
    this.isSelected = false,
    this.isLogged,
  });

  AdvisorFoodInfoLog copyWith({
    PassioAdvisorFoodInfo? advisorFoodInfoModel,
    bool? isSelected,
    bool? isLogged,
  }) {
    return AdvisorFoodInfoLog(
      advisorFoodInfoModel: advisorFoodInfoModel ?? this.advisorFoodInfoModel,
      isSelected: isSelected ?? this.isSelected,
      isLogged: isLogged ?? this.isLogged,
    );
  }
}

extension AdvisorFoodInfoLogExtension on AdvisorFoodInfoLog {
  AdvisorFoodInfoLog setSelection(bool isSelected) {
    return copyWith(isSelected: isSelected);
  }

  AdvisorFoodInfoLog setLogged(bool isLogged) {
    return copyWith(isLogged: isLogged);
  }
}

extension AdvisorFoodInfoLogListExtension on List<AdvisorFoodInfoLog> {
  List<AdvisorFoodInfoLog> clearSelection() {
    return map((e) => e.copyWith(isSelected: false)).toList();
  }

  List<AdvisorFoodInfoLog> toggleSelectionFor(int index) {
    AdvisorFoodInfoLog data = elementAt(index);
    data = data.copyWith(isSelected: !data.isSelected);
    this[index] = data;
    return this;
  }

  bool hasSelectedItems() {
    return any((e) => e.isSelected);
  }
}

extension SpeechRecognitionModelConversionExtension
    on List<PassioAdvisorFoodInfo> {
  List<AdvisorFoodInfoLog> toAdvisorFoodInfoLogList() {
    return map((e) =>
        AdvisorFoodInfoLog(advisorFoodInfoModel: e, isSelected: true)).toList();
  }
}
