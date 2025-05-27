import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../nutrition_ai_module.dart';
import '../../../common/data/repository/passio_connector_repository_impl.dart';
import '../../../common/domain/repository/passio_connector_repository.dart';
import '../../../common/domain/use_cases/passio_connector/update_water_use_case.dart';
import '../../../common/extension/core_extension.dart';
import '../../../common/router/routes.dart';
import '../../../common/util/snackbar_extension.dart';
import '../../../common/util/user_session.dart';
import '../../../common/widgets/app_bar/custom_app_bar.dart';
import 'bloc/add_water_bloc.dart';
import 'models/add_water_navigation_data_provider.dart';
import 'sections/water_form_section.dart';

part 'screen/add_water_screen.dart';

class AddWaterPage extends StatelessWidget {
  const AddWaterPage({required this.record, super.key});

  final WaterRecord? record;

  static MaterialPageRoute<bool?> route({WaterRecord? record}) {
    return MaterialPageRoute(
      settings: RouteSettings(name: Routes.addWaterPage),
      builder: (_) => AddWaterPage(record: record),
    );
  }

  @override
  Widget build(BuildContext context) {
    final UserProfileModel userProfile = UserSession.instance.userProfile!;

    final PassioConnector connector =
        NutritionAIModule.instance.configuration.connector;

    final PassioConnectorRepository repository =
        PassioConnectorRepositoryImpl(connector: connector);
    final UpdateWaterUseCase updateWaterUseCase =
        UpdateWaterUseCase(repository: repository);

    return AddWaterNavigationDataProvider(
      record: record,
      child: BlocProvider(
        create: (context) =>
            AddWaterBloc(updateWaterUseCase: updateWaterUseCase, userProfile: userProfile),
        child: const _AddWaterScreen(),
      ),
    );
  }
}
