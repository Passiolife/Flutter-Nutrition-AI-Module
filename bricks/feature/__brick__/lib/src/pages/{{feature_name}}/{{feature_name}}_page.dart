import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/{{feature_name}}_bloc.dart';

part 'screen/{{feature_name}}_screen.dart';

class {{feature_name.pascalCase()}}Page extends StatelessWidget {
  const {{feature_name.pascalCase()}}Page({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => {{feature_name.pascalCase()}}Bloc(),
      child: _{{feature_name.pascalCase()}}Screen(),
    );
  }
}