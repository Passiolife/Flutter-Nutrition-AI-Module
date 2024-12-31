import 'package:flutter/material.dart';

import '../../../../common/router/routes.dart';
import '../../../../common/util/navigation_utils/slide_page_route.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  static PageRouteBuilder route() {
    return SlidePageRoute(child: ResultScreen());
  }

  static Future navigate(BuildContext context) async {
    return await Navigator.pushNamed(
      context,
      Routes.takePhotoResult,
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
