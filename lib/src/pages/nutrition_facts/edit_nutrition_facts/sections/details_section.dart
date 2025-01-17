import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/edit_nutrition_facts_bloc.dart';
import '../widgets/details_widget.dart';

class DetailsSection extends StatefulWidget {
  const DetailsSection({super.key});

  @override
  State<DetailsSection> createState() => _DetailsSectionState();
}

class _DetailsSectionState extends State<DetailsSection> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditNutritionFactsBloc, EditNutritionFactsState>(
      builder: (context, state) {
        String iconId = '';
        String barcode = '';
        if (state is UpdateDetailsState) {
          iconId = state.iconId;
          barcode = state.barcode;
        }
        return DetailsWidget(
          iconId: iconId,
          nameController: _nameController,
          barcode: barcode,
        );
      },
    );
  }
}
