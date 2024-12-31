import 'package:flutter/material.dart';
import '../widgets/generating_result_widget.dart';
import '../widgets/result_top_widget.dart';

class ResultSection extends StatelessWidget {
  const ResultSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          ResultTopWidget(),
          AnalyzingWidget(),
        ],
    );
  }
}
