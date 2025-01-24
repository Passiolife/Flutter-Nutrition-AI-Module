import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/router/routes.dart';
import '../bloc/edit_nutrition_facts_bloc.dart';
import '../widgets/details_widget.dart';

class DetailsSection extends StatefulWidget {
  const DetailsSection({super.key});

  @override
  State<DetailsSection> createState() => _DetailsSectionState();
}

class _DetailsSectionState extends State<DetailsSection> {

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditNutritionFactsBloc, EditNutritionFactsState>(
      buildWhen: (previous, current) => current is RefreshDetailsState,
      builder: (context, state) {
        String? iconId;
        String? name;
        String? barcode;
        Uint8List? imageBytes;
        if (state is RefreshDetailsState) {
          iconId = state.iconId;
          name = state.name;
          barcode = state.barcode;
          imageBytes = state.imageBytes;
        }
        return DetailsWidget(
          iconId: iconId,
          initialName: name,
          onNameChanged: _onNameChanged,
          barcode: barcode,
          imageBytes: imageBytes,
          onTapBarcode: _onTapBarcode,
        );
      },
    );
  }

  void _onNameChanged(String name) {
    context.read<EditNutritionFactsBloc>().add(UpdateNameEvent(name: name));
  }

  void _onTapBarcode() async {
    String? barcode = await Navigator.pushNamed<String>(context, Routes.barcodeScanner);
    if ((barcode?.isNotEmpty ?? false) && mounted) {
      context.read<EditNutritionFactsBloc>().add(UpdateBarcodeEvent(barcode: barcode!));
    }
  }


}
