part of '../home_page.dart';

class _HomeScreen extends StatelessWidget {
  const _HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const HomeAppBarSection(),
        Expanded(
          child: Padding(
            padding: AppPadding.pa16,
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(
                children: [
                  const DailyNutritionSection(),
                  16.verticalSpace,
                  const WeeklyAdherenceSection(),
                  16.verticalSpace,
                  const WeightWaterSection(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
