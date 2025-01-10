part of '../nutrition_facts_page.dart';

class _NutritionFactsScreen extends StatefulWidget {
  const _NutritionFactsScreen();

  @override
  State<_NutritionFactsScreen> createState() => _NutritionFactsScreenState();
}

class _NutritionFactsScreenState extends State<_NutritionFactsScreen> {
  bool _seenIntroDialog = true;

  NutritionFactsBloc? get _bloc =>
      mounted ? context.read<NutritionFactsBloc>() : null;

  int _section = 0;

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _bloc?.add(const DoCheckIntroScreenEvent());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NutritionFactsBloc, NutritionFactsState>(
      listener: (context, state) {
        _handleStateChanges(context, state);
      },
      buildWhen: (_, state) {
        return state is InitialBuilderState ||
            state is UpdateSectionBuilderState;
      },
      builder: (BuildContext context, NutritionFactsState state) {
        if (state is UpdateSectionBuilderState) {
          _section = state.section;
        }
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: _seenIntroDialog
              ? Column(
                  children: [
                    const HeaderSection(),
                    Expanded(
                      child: IndexedStack(
                        index: _section,
                        children: [
                          const CameraSection(),
                          PreviewSection(
                            key: UniqueKey(),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : const SizedBox.shrink(),
        );
      },
    );
  }

  void _handleStateChanges(BuildContext context, NutritionFactsState state) {
    if (state is ShowIntroDialogListenerState) {
      _showIntroDialog(context);
    } else if (state is BothNotFoundState) {
      _showNutritionFactsNotFoundDialog(context: context);
    } else if (state is NutritionFactsNotFoundState) {
      _showNutritionFactsNotFoundDialog(context: context);
    } else if (state is IngredientsNotFoundState) {
      _showIngredientsNotFoundDialog(context: context);
    } else if (state is FailedToAnalyzedState) {
      _showFailedToAnalyzedState(context: context);
    }
  }

  void _showIntroDialog(BuildContext context) {
    ShowWidgetUtil.showCustomGeneralDialogNew(
      context: context,
      builder: (BuildContext context) {
        return CaptureNutritionFactsLabelWidget(
          onTap: () {
            Navigator.pop(context);
            _bloc?.add(const DoIntroScreenCompletedEvent(fromDialog: true));
          },
        );
      },
    );
  }

  void _showNutritionFactsNotFoundDialog({required BuildContext context}) {
    ShowWidgetUtil.showCustomGeneralDialogNew(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dContext) {
        return NoNutritionFactsLabelFoundWidget(
          onTapNegative: () {
            Navigator.pop(dContext);
            _bloc?.add(UpdateSectionEvent(section: 0));
          },
          onTapPositive: () {
            Navigator.pop(dContext);
          },
          // onTap: () {
          //   Navigator.pop(context);
          //   _bloc?.add(const DoIntroScreenCompletedEvent(fromDialog: true));
          // },
        );
      },
    );
  }

  void _showIngredientsNotFoundDialog({required BuildContext context}) {
    ShowWidgetUtil.showCustomGeneralDialogNew(
      context: context,
      builder: (BuildContext context) {
        return NoIngredientsLabelFoundWidget(
            // onTap: () {
            //   Navigator.pop(context);
            //   _bloc?.add(const DoIntroScreenCompletedEvent(fromDialog: true));
            // },
            );
      },
    );
  }

  void _showFailedToAnalyzedState({required BuildContext context}) {
    ShowWidgetUtil.showCustomGeneralDialogNew(
      context: context,
      builder: (BuildContext context) {
        return FailedToAnalyzeImageWidget(
            // onTap: () {
            //   Navigator.pop(context);
            //   _bloc?.add(const DoIntroScreenCompletedEvent(fromDialog: true));
            // },
            );
      },
    );
  }
}
