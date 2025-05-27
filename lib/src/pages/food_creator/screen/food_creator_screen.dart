part of '../food_creator_page.dart';

class _FoodCreatorScreen extends StatefulWidget {
  const _FoodCreatorScreen();

  @override
  State<_FoodCreatorScreen> createState() => _FoodCreatorScreenState();
}

class _FoodCreatorScreenState extends State<_FoodCreatorScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  FoodCreatorNavigationDataModel get _navigationData =>
      FoodCreatorNavigationDataModel.of(context);

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FoodCreatorBloc, FoodCreatorState>(
      listener: _handleStateListener,
      child: Scaffold(
        appBar: PrimaryAppBar(
          title: context.localization.foodCreator,
        ),
        bottomNavigationBar: ActionButtonsSection(
          doValidate: _doValidate,
        ),
        body: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            padding: context.bottomPadding + AppPadding.pb16,
            child: Form(
              key: _formKey,
              child: Column(
                children: const [
                  FoodDetailsSection(),
                  RequiredNutritionFactsSection(),
                  OtherNutritionFactsSection(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleStateListener(BuildContext context, FoodCreatorState state) {
    if (state is SaveErrorState) {
      context.showSnackbar(text: state.message);
    } else if (state is SaveSuccessState) {
      Navigator.pop(context, true);
    }
  }

  bool _doValidate() {
    return _formKey.currentState?.validate() ?? false;
  }

  void _initialize() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      context.read<FoodCreatorBloc>().add(DoConversionEvent(
            index: _navigationData.index,
            foodRecord: _navigationData.foodRecord,
          ));
    });
  }
}
