import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'my_foods_event.dart';
part 'my_foods_state.dart';

class MyFoodsBloc extends Bloc<MyFoodsEvent, MyFoodsState> {
  MyFoodsBloc() : super(const MyFoodsInitial());
}
