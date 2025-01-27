import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../../../nutrition_ai_module.dart';
import '../../common/extension/context_extension.dart';
import '../../common/permission_manager/permission_manager.dart';
import '../../common/router/routes.dart';
import '../../common/util/show_widget_util.dart';
import '../../common/widgets/app_bar/custom_app_bar.dart';
import '../edit_food/ui/edit_food_page.dart';
import 'bloc/barcode_scanner_bloc.dart';
import 'sections/camera_section.dart';
import 'widgets/barcode_in_system_widget.dart';
import 'widgets/custom_food_already_exists_widget.dart';

part 'screen/barcode_scanner_screen.dart';

class BarcodeScannerPage extends StatelessWidget {
  const BarcodeScannerPage({super.key});

  static MaterialPageRoute route() {
    return MaterialPageRoute(
      builder: (_) => const BarcodeScannerPage(),
    );
  }

  static Future navigate({required BuildContext context}) async {
    return await Navigator.pushNamed(
      context,
      Routes.barcodeScanner,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BarcodeScannerBloc(),
      child: const _BarcodeScannerScreen(),
    );
  }
}
