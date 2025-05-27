part of '{{feature_name}}_bloc.dart';

sealed class {{feature_name.pascalCase()}}State  extends Equatable {
  const {{feature_name.pascalCase()}}State();
}

final class InitialState extends {{feature_name.pascalCase()}}State {
  const InitialState();

  @override
  List<Object?> get props => [];
}
