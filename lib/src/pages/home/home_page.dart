import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../nutrition_ai_module.dart';
import '../../common/constant/app_padding.dart';
import '../../common/data/repository/passio_connector_repository_impl.dart';
import '../../common/domain/repository/passio_connector_repository.dart';
import '../../common/domain/use_cases/passio_connector/fetch_consumed_water_use_case.dart';
import '../../common/domain/use_cases/passio_connector/fetch_day_logs_use_case.dart';
import '../../common/domain/use_cases/passio_connector/fetch_measured_weight_use_case.dart';
import '../../common/domain/use_cases/passio_connector/fetch_records_use_case.dart';
import '../../common/util/user_session.dart';
import 'bloc_/home_bloc.dart';
import 'sections/daily_nutrition_section.dart';
import 'sections/home_app_bar_section.dart';
import 'sections/water_weight_section.dart';
import 'sections/weekly_adherence_section.dart';

part 'screen/home_screen.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final PassioConnector connector =
        NutritionAIModule.instance.configuration.connector;
    final PassioConnectorRepository repository =
        PassioConnectorRepositoryImpl(connector: connector);
    final FetchRecordsUseCase fetchRecordsUseCase =
        FetchRecordsUseCase(repository: repository);
    final FetchDayLogsUseCase fetchDayLogsUseCase =
        FetchDayLogsUseCase(useCase: fetchRecordsUseCase);
    final FetchMeasuredWeightUseCase fetchMeasuredWeightUseCase =
        FetchMeasuredWeightUseCase(repository: repository);
    final FetchConsumedWaterUseCase fetchConsumedWaterUseCase =
        FetchConsumedWaterUseCase(repository: repository);
    final userProfile = UserSession.instance.userProfile!;

    return BlocProvider(
      create: (context) => HomeBloc(
        fetchDayLogsUseCase: fetchDayLogsUseCase,
        fetchMeasuredWeightUseCase: fetchMeasuredWeightUseCase,
        fetchConsumedWaterUseCase: fetchConsumedWaterUseCase,
        profileModel: userProfile,
      ),
      child: const _HomeScreen(),
    );
  }
}
