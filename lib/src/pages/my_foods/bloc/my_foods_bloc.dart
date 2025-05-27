import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'my_foods_event.dart';
part 'my_foods_state.dart';

class MyFoodsBloc extends Bloc<MyFoodsEvent, MyFoodsState> {

  int _page = 0;

  int get page => _page;

  MyFoodsBloc() : super(const InitialState()) {
    on<TabChangeEvent>(_handleTabChangeEvent);
    on<PageChangeEvent>(_handlePageChangeEvent);
  }

  Future<void> _handleTabChangeEvent(TabChangeEvent event, Emitter<MyFoodsState> emit) async {
    _page = event.page;
    emit(TabChangedState(page: _page));
  }

  Future<void> _handlePageChangeEvent(PageChangeEvent event, Emitter<MyFoodsState> emit) async {
    _page = event.page;
    emit(PageChangedState(page: _page));
  }
}