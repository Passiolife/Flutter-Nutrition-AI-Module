import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'weight_event.dart';
part 'weight_state.dart';

class WeightBloc extends Bloc<WeightEvent, WeightState> {


  WeightBloc() : super(const InitialState()) {
    on<UpdateTabEvent>(_handleUpdateTabEvent);
    on<UpdatePageEvent>(_handleUpdatePageEvent);
  }

  int _selectedTab = 0;
  int get selectedTab => _selectedTab;

  void _handleUpdateTabEvent(UpdateTabEvent event, Emitter<WeightState> emit) {
    _selectedTab = event.tab;
    emit(UpdateTabState(tab: _selectedTab));
  }

  void _handleUpdatePageEvent(UpdatePageEvent event, Emitter<WeightState> emit) {
    _selectedTab = event.page;
    emit(UpdatePageState(page: _selectedTab));
  }
}