part of '../my_foods_page.dart';

class _MyFoodsScreen extends StatelessWidget {
  const _MyFoodsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const MyFoodsAppBarSection(),
          const MyFoodsTabBarSection(),
          const MyFoodsBodySection(),
        ],
      ),
    );
  }
}