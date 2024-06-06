import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'progress_event.dart';
part 'progress_state.dart';

class ProgressBloc extends Bloc<ProgressEvent, ProgressState> {
  ProgressBloc() : super(ProgressInitial()) {
    on<ProgressEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
