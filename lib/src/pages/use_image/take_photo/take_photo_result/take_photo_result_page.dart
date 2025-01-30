import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../nutrition_ai_module.dart';
import '../../../../common/constant/app_shadow.dart';
import '../../../../common/data/repository/custom_food_repository_impl.dart';
import '../../../../common/data/repository/food_log_repositoy_impl.dart';
import '../../../../common/data/repository/nutrition_ai_repository_impl.dart';
import '../../../../common/domain/repository/food_log_repositoy.dart';
import '../../../../common/domain/use_cases/custom_food/add_custom_food_use_case.dart';
import '../../../../common/domain/use_cases/custom_food/add_custom_foods_use_case.dart';
import '../../../../common/domain/use_cases/food_logs/add_food_logs_use_case.dart';
import '../../../../common/domain/use_cases/nutrition_ai/get_food_records_by_image_recognition.dart';
import '../../../../common/extension/context_extension.dart';
import '../../../../common/extension/string_extensions.dart';
import '../../../../common/router/routes.dart';
import '../../../../common/util/image_utility/image_utility_impl.dart';
import '../../../../common/util/navigation_utils/slide_page_route.dart';
import '../../../../common/util/show_widget_util.dart';
import '../../../../common/widgets/item_added_to_diary_widget.dart';
import '../../../../nutrition_ai_module_configuration.dart';
import '../../../my_foods/recipes/recipe_creator/ui/model/navigation_data_provider.dart';
import 'bloc/take_photo_result_bloc.dart';
import 'models/take_photo_result_navigation_data_provider.dart';
import 'sections/action_buttons_section.dart';
import 'sections/food_items_list_section.dart';
import 'sections/generating_results_section.dart';
import 'sections/macros_graph_section.dart';
import 'sections/no_results_found_section.dart';
import 'sections/result_header_section.dart';

part 'screen/take_photo_result_screen.dart';

class TakePhotoResultPage extends StatelessWidget {
  const TakePhotoResultPage({required this.capturedImages, super.key});

  final List<Uint8List>? capturedImages;

  static PageRouteBuilder route({List<Uint8List>? capturedImages}) {
    return SlidePageRoute(
      settings: RouteSettings(name: Routes.takePhotoResult),
      child: TakePhotoResultPage(
        capturedImages: capturedImages,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final NutritionConfiguration configuration =
        NutritionAIModule.instance.configuration;

    final imageUtility = ImageUtilityImpl();
    final nutritionAIRepository = NutritionAIRepositoryImpl();
    final FoodLogRepository repository =
        FoodLogRepositoryImpl(connector: configuration.connector);

    final foodRecordsByImageRecognition = GetFoodRecordsByImageRecognition(
      repository: nutritionAIRepository,
      imageUtility: imageUtility,
    );

    final customFoodRepository =
        CustomFoodRepositoryImpl(connector: configuration.connector);
    final addCustomFoodUseCase =
        AddCustomFoodUseCase(customFoodRepository: customFoodRepository);

    return TakePhotoResultNavigationDataProvider(
      capturedImages: capturedImages,
      child: BlocProvider(
        create: (context) => TakePhotoResultBloc(
          nutritionConfiguration: NutritionAIModule.instance.configuration,
          foodRecordsByImageRecognition: foodRecordsByImageRecognition,
          addFoodLogsUseCase: AddFoodLogsUseCase(repository: repository),
          addCustomFoodsUseCase:
              AddCustomFoodsUseCase(addCustomFoodUseCase: addCustomFoodUseCase),
        ),
        child: _TakePhotoResultScreen(),
      ),
    );
  }
}
