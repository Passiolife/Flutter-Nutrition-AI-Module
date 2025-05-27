import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../common/connectors/passio_connector.dart';
import '../../common/data/repository/passio_connector_repository_impl.dart';
import '../../common/domain/repository/passio_connector_repository.dart';
import '../../common/domain/use_cases/passio_connector/fetch_user_recipes_use_case.dart';
import '../../nutrition_ai_module_sdk.dart';
import 'bloc/recipes_bloc.dart';
import 'sections/action_buttons_section.dart';
import 'sections/recipe_list_section.dart';

part 'screen/recipes_screen.dart';

class RecipesPage extends StatefulWidget {
  const RecipesPage({super.key});

  @override
  State<RecipesPage> createState() => _RecipesPageState();
}

class _RecipesPageState extends State<RecipesPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    final PassioConnector connector = NutritionAIModule.instance.configuration.connector;
    final PassioConnectorRepository repository =
        PassioConnectorRepositoryImpl(connector: connector);
    final FetchUserRecipesUseCase fetchUserRecipesUseCase =
        FetchUserRecipesUseCase(repository: repository);

    return BlocProvider(
      create: (context) =>
          RecipesBloc(fetchUserRecipesUseCase: fetchUserRecipesUseCase),
      child: _RecipesScreen(),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
