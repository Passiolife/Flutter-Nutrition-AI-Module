part of '../add_water_page.dart';

class _AddWaterScreen extends StatefulWidget {
  const _AddWaterScreen();

  @override
  State<_AddWaterScreen> createState() => _AddWaterScreenState();
}

class _AddWaterScreenState extends State<_AddWaterScreen> {
  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _setInitialData(context: context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final WaterRecord? record =
        AddWaterNavigationDataProvider.of(context).record;
    return BlocListener<AddWaterBloc, AddWaterState>(
      listener: _handleStateListener,
      child: Scaffold(
        body: Column(
          children: [
            CustomAppBar(
              title: record?.id == null
                  ? context.localization.newEntry
                  : context.localization.editEntry,
            ),
            8.verticalSpace,
            Expanded(child: WaterFormSection()),
            (context.bottomPaddingValue + 16).verticalSpace,
          ],
        ),
      ),
    );
  }

  void _handleStateListener(BuildContext context, AddWaterState state) {
    if (state is SaveSuccessState) {
      Navigator.pop(context, true);
    } else if (state is SaveFailureState) {
      context.showSnackbar(text: state.error);
    }
  }

  void _setInitialData({required BuildContext context}) {
    final WaterRecord? record =
        AddWaterNavigationDataProvider.of(context).record;
    if (record == null) {
      return;
    }
    context.read<AddWaterBloc>().add(UpdateWaterRecordEvent(record: record));
  }
}
