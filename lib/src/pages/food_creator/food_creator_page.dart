import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/constant/app_padding.dart';
import '../../common/data/repository/passio_connector_repository_impl.dart';
import '../../common/domain/repository/passio_connector_repository.dart';
import '../../common/domain/use_cases/passio_connector/fetch_user_food_image_use_case.dart';
import '../../common/domain/use_cases/passio_connector/update_user_food_image_use_case.dart';
import '../../common/domain/use_cases/passio_connector/update_user_food_use_case.dart';
import '../../common/extension/core_extension.dart';
import '../../common/models/food_record/food_record.dart';
import '../../common/router/routes.dart';
import '../../common/util/snackbar_extension.dart';
import '../../common/widgets/app_bar/primary_app_bar.dart';
import '../../nutrition_ai_module_sdk.dart';
import 'bloc/food_creator_bloc.dart';
import 'models/food_creator_navigation_data_model.dart';
import 'sections/action_buttons_section.dart';
import 'sections/food_details_section.dart';
import 'sections/other_nutrition_facts_section.dart';
import 'sections/required_nutrition_facts_section.dart';

part 'screen/food_creator_screen.dart';

class FoodCreatorPage extends StatelessWidget {
  const FoodCreatorPage({this.index, this.foodRecord, super.key});

  final int? index;
  final FoodRecord? foodRecord;

  static MaterialPageRoute<bool> route({int? index, FoodRecord? foodRecord}) {
    return MaterialPageRoute<bool>(
      settings: RouteSettings(name: Routes.foodCreator),
      builder: (_) => FoodCreatorPage(
        index: index,
        foodRecord: foodRecord,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final connector = NutritionAIModule.instance.configuration.connector;
    final PassioConnectorRepository repository =
        PassioConnectorRepositoryImpl(connector: connector);
    final UpdateUserFoodUseCase updateUserFoodUseCase =
        UpdateUserFoodUseCase(repository: repository);
    final UpdateUserFoodImageUseCase updateUserFoodImageUseCase =
        UpdateUserFoodImageUseCase(repository: repository);
    final FetchUserFoodImageUseCase fetchUserFoodImageUseCase =
        FetchUserFoodImageUseCase(repository: repository);

    return FoodCreatorNavigationDataModel(
      index: index,
      foodRecord: foodRecord,
      child: BlocProvider(
        create: (context) => FoodCreatorBloc(
          updateUserFoodUseCase: updateUserFoodUseCase,
          updateUserFoodImageUseCase: updateUserFoodImageUseCase,
          fetchUserFoodImageUseCase: fetchUserFoodImageUseCase,
        ),
        child: _FoodCreatorScreen(),
      ),
    );
  }
}
