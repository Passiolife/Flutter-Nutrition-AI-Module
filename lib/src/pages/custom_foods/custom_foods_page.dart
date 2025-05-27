import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../common/connectors/passio_connector.dart';
import '../../common/data/repository/passio_connector_repository_impl.dart';
import '../../common/domain/repository/passio_connector_repository.dart';
import '../../common/domain/use_cases/passio_connector/delete_user_food_record_use_case.dart';
import '../../common/domain/use_cases/passio_connector/fetch_user_foods_use_case.dart';
import '../../nutrition_ai_module_sdk.dart';
import 'bloc/custom_foods_bloc.dart';
import 'sections/custom_foods_create_new_section.dart';
import 'sections/custom_foods_list_section.dart';

part 'screen/custom_foods_screen.dart';

class CustomFoodsPage extends StatefulWidget {
  const CustomFoodsPage({super.key});

  @override
  State<CustomFoodsPage> createState() => _CustomFoodsPageState();
}

class _CustomFoodsPageState extends State<CustomFoodsPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    final PassioConnector connector =
        NutritionAIModule.instance.configuration.connector;
    final PassioConnectorRepository repository =
        PassioConnectorRepositoryImpl(connector: connector);
    final FetchUserFoodsUseCase fetchUserFoodsUseCase =
        FetchUserFoodsUseCase(repository: repository);
    final DeleteUserFoodRecordUseCase deleteUserFoodRecordUseCase =
        DeleteUserFoodRecordUseCase(repository: repository);

    super.build(context);
    return BlocProvider(
      create: (context) => CustomFoodsBloc(
          fetchUserFoodsUseCase: fetchUserFoodsUseCase,
          deleteUserFoodRecordUseCase: deleteUserFoodRecordUseCase),
      child: _CustomFoodsScreen(),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
