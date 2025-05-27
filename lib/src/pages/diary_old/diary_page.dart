import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/router/routes.dart';
import 'bloc/diary_bloc.dart';

part 'screen/diary_screen.dart';

class DiaryPage extends StatelessWidget {
  const DiaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DiaryBloc(),
      child: const _DiaryScreen(),
    );
  }
}
