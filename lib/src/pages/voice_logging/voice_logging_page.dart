import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../common/constant/app_constants.dart';
import '../../common/util/context_extension.dart';
import '../../common/util/show_widget_util.dart';
import '../../common/util/snackbar_extension.dart';
import '../../common/widgets/bottom_sheet/no_results_found_bottom_sheet.dart';
import '../../common/widgets/custom_app_bar_widget.dart';
import '../dashboard/bloc/dashboard_bloc.dart';
import '../dashboard/dashboard_page.dart';
import '../food_search/food_search_page.dart';
import 'bloc/voice_logging_bloc.dart';
import 'sections/recognized_text_section.dart';
import 'sections/voice_control_buttons_section.dart';
import 'sections/voice_processing_section.dart';
import 'sections/voice_result_section.dart';

part 'screen/voice_logging_screen.dart';

class VoiceLoggingPage extends StatelessWidget {
  const VoiceLoggingPage({super.key});

  static Future navigate(BuildContext context) async {
    return await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: BlocProvider.of<DashboardBloc>(context),
          child: const VoiceLoggingPage(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => VoiceLoggingBloc(),
      child: _VoiceLoggingScreen(),
    );
  }
}
