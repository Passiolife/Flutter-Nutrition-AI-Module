import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../nutrition_ai_module.dart';
import '../../../common/data/repository/passio_connector_repository_impl.dart';
import '../../../common/domain/repository/passio_connector_repository.dart';
import '../../../common/domain/use_cases/passio_connector/delete_water_record_use_case.dart';
import '../../../common/domain/use_cases/passio_connector/fetch_water_records_use_case.dart';
import '../../../common/domain/use_cases/passio_connector/update_water_use_case.dart';
import '../../../common/extension/core_extension.dart';
import '../../../common/router/routes.dart';
import '../../../common/util/snackbar_extension.dart';
import '../../../common/util/user_session.dart';
import 'bloc/water_bloc.dart';
import 'sections/water_app_bar_section.dart';
import 'sections/water_body_section.dart';
import 'sections/water_tab_bar_section.dart';

part 'screen/water_screen.dart';

class WaterPage extends StatelessWidget {
  const WaterPage({super.key});

  static MaterialPageRoute route() {
    return MaterialPageRoute(
      settings: RouteSettings(name: Routes.waterPage),
      builder: (_) => const WaterPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final UserProfileModel userProfile = UserSession.instance.userProfile!;

    final PassioConnector connector =
        NutritionAIModule.instance.configuration.connector;

    final PassioConnectorRepository repository =
        PassioConnectorRepositoryImpl(connector: connector);
    final FetchWaterRecordsUseCase fetchWaterRecordsUseCase =
        FetchWaterRecordsUseCase(repository: repository);
    final UpdateWaterUseCase updateWaterUseCase =
        UpdateWaterUseCase(repository: repository);
    final DeleteWaterRecordUseCase deleteWaterRecordUseCase =
        DeleteWaterRecordUseCase(repository: repository);

    return BlocProvider(
      create: (context) => WaterBloc(
        userProfile: userProfile,
        fetchWaterRecordsUseCase: fetchWaterRecordsUseCase,
        updateWaterUseCase: updateWaterUseCase,
        deleteWaterRecordUseCase: deleteWaterRecordUseCase,
      ),
      child: _WaterScreen(),
    );
  }
}
