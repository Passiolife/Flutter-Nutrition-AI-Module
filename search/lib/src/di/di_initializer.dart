import 'package:get_it/get_it.dart';
import 'package:search/src/view/bloc/search_bloc.dart';

const String _initializedMark = 'search_initialized';

void initialize() {
  final isInitialized = GetIt.I.isRegistered<bool>(instanceName: _initializedMark);

  if(!isInitialized) {
    GetIt.I.registerSingleton<bool>(true, instanceName: _initializedMark);
    GetIt.I.registerFactory(() => SearchBloc());
  }
}