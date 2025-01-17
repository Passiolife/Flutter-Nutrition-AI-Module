import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../common/data/repository/nutrition_ai_repository_impl.dart';
import '../../common/extension/context_extension.dart';
import '../../common/router/routes.dart';
import '../../common/util/show_widget_util.dart';
import '../../common/widgets/app_bar/custom_app_bar.dart';
import '../nutrition_facts/edit_nutrition_facts/edit_nutrition_facts_page.dart';
import 'bloc/photo_preview_bloc.dart';
import 'models/navigation_data_provider.dart';
import 'sections/analyze_progress_section.dart';
import 'sections/image_preview_section.dart';
import 'widgets/action_button_widget.dart';
import '../nutrition_facts/widgets/no_ingredients_label_found_widget.dart';
import '../nutrition_facts/widgets/no_nutrition_facts_label_found_widget.dart';

part 'screen/photo_preview_screen.dart';

class PhotoPreviewPage extends StatelessWidget {
  const PhotoPreviewPage({required this.file, super.key});

  final XFile? file;

  static MaterialPageRoute route({XFile? file}) {
    return MaterialPageRoute(
      settings: RouteSettings(name: Routes.photoPreview),
      builder: (_) => PhotoPreviewPage(file: file),
    );
  }

  @override
  Widget build(BuildContext context) {
    return NavigationDataProvider(
      file: File(file!.path),
      child: BlocProvider(
        create: (context) => PhotoPreviewBloc(nutritionAIRepository: NutritionAIRepositoryImpl()),
        child: _PhotoPreviewScreen(),
      ),
    );
  }
}
