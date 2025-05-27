part of 'diary_bloc.dart';

sealed class DiaryState extends Equatable {
  const DiaryState();
}

final class DiaryInitial extends DiaryState {
  const DiaryInitial();

  @override
  List<Object> get props => [];
}
