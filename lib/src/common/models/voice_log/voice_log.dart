import 'package:nutrition_ai/nutrition_ai.dart';

class VoiceLog {
  final PassioSpeechRecognitionModel? recognitionModel;
  final bool isSelected;

  const VoiceLog({this.recognitionModel, this.isSelected = false});

  VoiceLog copyWith({
    PassioSpeechRecognitionModel? recognitionModel,
    bool? isSelected,
  }) {
    return VoiceLog(
      recognitionModel: recognitionModel ?? this.recognitionModel,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}

extension VoiceLogExtension on VoiceLog {
  VoiceLog setSelection(bool isSelected) {
    return copyWith(isSelected: isSelected);
  }
}

extension VoiceLogListExtension on List<VoiceLog> {
  List<VoiceLog> clearSelection() {
    return map((e) => e.copyWith(isSelected: false)).toList();
  }

  List<VoiceLog> toggleSelectionFor(int index) {
    VoiceLog data = elementAt(index);
    data = data.copyWith(isSelected: !data.isSelected);
    this[index] = data;
    return this;
  }

  bool hasSelectedItems() {
    return any((e) => e.isSelected);
  }
}

extension SpeechRecognitionModelConversionExtension
    on List<PassioSpeechRecognitionModel> {
  List<VoiceLog> toVoiceLogList() {
    return map((e) => VoiceLog(recognitionModel: e, isSelected: true)).toList();
  }
}
