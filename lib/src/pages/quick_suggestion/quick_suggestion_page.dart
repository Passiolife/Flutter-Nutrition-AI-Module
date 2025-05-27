import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../nutrition_ai_module.dart';
import '../../common/constant/app_constants.dart';
import '../../common/data/repository/nutrition_ai_repository_impl.dart';
import '../../common/data/repository/passio_connector_repository_impl.dart';
import '../../common/domain/repository/nutrition_ai_repository.dart';
import '../../common/domain/repository/passio_connector_repository.dart';
import '../../common/domain/use_cases/nutrition_ai/fetch_food_item_for_data_info_use_case.dart';
import '../../common/domain/use_cases/nutrition_ai/fetch_suggestions_use_case.dart';
import '../../common/domain/use_cases/passio_connector/fetch_day_records_use_case.dart';
import '../../common/domain/use_cases/passio_connector/fetch_records_use_case.dart';
import '../../common/domain/use_cases/passio_connector/update_record_use_case.dart';
import '../../common/extension/core_extension.dart';
import '../../common/widgets/draggable_bottom_sheet_widget.dart';
import 'bloc/quick_suggestion_bloc.dart';
import 'sections/body_section.dart';
import 'sections/header_section.dart';

part 'screen/quick_suggestion_screen.dart';

class QuickSuggestionPage extends StatelessWidget {
  const QuickSuggestionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final PassioConnector connector =
        NutritionAIModule.instance.configuration.connector;
    final PassioConnectorRepository repository =
        PassioConnectorRepositoryImpl(connector: connector);
    final FetchRecordsUseCase fetchRecordsUseCase =
        FetchRecordsUseCase(repository: repository);

    final NutritionAIRepository nutritionAIRepository =
        NutritionAIRepositoryImpl();
    final FetchSuggestionsUseCase fetchSuggestionsUseCase =
        FetchSuggestionsUseCase(repository: nutritionAIRepository);

    final fetchDayRecordsUseCase = FetchDayRecordsUseCase(repository);

    final updateRecordUseCase = UpdateRecordUseCase(repository: repository);
    final fetchFoodItemForDataInfoUseCase =
        FetchFoodItemForDataInfoUseCase(repository: nutritionAIRepository);

    return BlocProvider(
      create: (context) => QuickSuggestionBloc(
        fetchRecordsUseCase: fetchRecordsUseCase,
        fetchSuggestionsUseCase: fetchSuggestionsUseCase,
        fetchDayRecordsUseCase: fetchDayRecordsUseCase,
        updateRecordUseCase: updateRecordUseCase,
        fetchFoodItemForDataInfoUseCase: fetchFoodItemForDataInfoUseCase,
      ),
      child: _QuickSuggestionScreen(),
    );
  }
}
