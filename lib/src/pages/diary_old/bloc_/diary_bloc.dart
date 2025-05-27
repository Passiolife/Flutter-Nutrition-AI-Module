import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'diary_event.dart';
part 'diary_state.dart';

class DiaryBloc extends Bloc<DiaryEvent, DiaryState> {
  DiaryBloc() : super(DiaryInitial()) {
    on<DiaryEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
