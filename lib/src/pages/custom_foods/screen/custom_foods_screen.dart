part of '../custom_foods_page.dart';

class _CustomFoodsScreen extends StatelessWidget {
  const _CustomFoodsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<CustomFoodsBloc, CustomFoodsState>(
      listener: _handleStateListener,
      child: Scaffold(
        body: SafeArea(
          top: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Expanded(
                child: CustomFoodsSection(),
              ),
              const CustomFoodsCreateNewSection(),
              8.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }

  void _handleStateListener(BuildContext context, CustomFoodsState state) {
    if (state is FetchSuccessState) {}
  }
}
