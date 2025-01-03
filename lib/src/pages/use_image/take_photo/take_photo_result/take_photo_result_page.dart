import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../common/constant/app_shadow.dart';
import '../../../../common/data/repository/nutrition_ai_repository_impl.dart';
import '../../../../common/domain/use_cases/nutrition_ai/get_food_records_by_image_recognition.dart';
import '../../../../common/extension/context_extension.dart';
import '../../../../common/util/navigation_utils/slide_page_route.dart';
import 'bloc/take_photo_result_bloc.dart';
import 'models/take_photo_result_navigation_data_provider.dart';
import 'sections/action_buttons_section.dart';
import 'sections/food_items_list_section.dart';
import 'sections/generating_results_section.dart';
import 'sections/macros_graph_section.dart';
import 'sections/result_header_section.dart';
import 'widgets/barcode_missing_data_widget.dart';

part 'screen/take_photo_result_screen.dart';

class TakePhotoResultPage extends StatelessWidget {
  const TakePhotoResultPage({required this.capturedImages, super.key});

  final List<Uint8List>? capturedImages;

  static PageRouteBuilder route({List<Uint8List>? capturedImages}) {
    return SlidePageRoute(
      child: TakePhotoResultPage(
        capturedImages: capturedImages,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TakePhotoResultNavigationDataProvider(
      capturedImages: capturedImages,
      child: BlocProvider(
        create: (context) => TakePhotoResultBloc(
          foodRecordsByImageRecognition: GetFoodRecordsByImageRecognition(
            repository: NutritionAIRepositoryImpl(),
          ),
        ),
        child: _TakePhotoResultScreen(),
      ),
    );
  }
}
