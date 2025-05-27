import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/router/routes.dart';
import '../bloc/food_creator_bloc.dart';
import '../models/food_creator_navigation_data_model.dart';
import '../widgets/food_details_widget.dart';

class FoodDetailsSection extends StatelessWidget {
  const FoodDetailsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FoodCreatorBloc, FoodCreatorState>(
      buildWhen: (_, state) =>
          state is InitialState || state is UpdateFoodDetailsState,
      builder: (context, state) {
        final String? initialNameValue =
            context.read<FoodCreatorBloc>().creatorModel.getName();
        final String? initialBrandValue =
            context.read<FoodCreatorBloc>().creatorModel.getBrand();
        final Uint8List? initialImageValue =
            context.read<FoodCreatorBloc>().creatorModel.getImage();
        final String? initialBarcodeValue =
            context.read<FoodCreatorBloc>().creatorModel.getBarcode();
        final String? iconId = context.read<FoodCreatorBloc>().creatorModel.getIconId();

        return FoodDetailsWidget(
          image: initialImageValue,
          iconId: iconId,
          initialNameValue: initialNameValue,
          onNameChanged: (value) =>
              _onNameChanged(context: context, value: value),
          initialBrandValue: initialBrandValue,
          onBrandChanged: (value) =>
              _onBrandChanged(context: context, value: value),
          initialBarcodeValue: initialBarcodeValue,
          onImageChanged: (value) =>
              _onImageChanged(context: context, value: value),
          onTapBarcode: () => _onBarcodeTapped(context: context),
        );
      },
    );
  }

  void _onNameChanged({required BuildContext context, required String value}) {
    context.read<FoodCreatorBloc>().add(UpdateNameEvent(name: value));
  }

  void _onBrandChanged({required BuildContext context, required String value}) {
    context.read<FoodCreatorBloc>().add(UpdateBrandEvent(brand: value));
  }

  void _onImageChanged({required BuildContext context, Uint8List? value}) {
    context.read<FoodCreatorBloc>().add(UpdateImageEvent(image: value));
  }

  Future<void> _onBarcodeTapped({required BuildContext context}) async {
    final result = await Navigator.pushNamed(context, Routes.barcodeScanner);
    if (result == null || context.mounted == false) {
      return;
    }

    if (result is String) {
      context.read<FoodCreatorBloc>().add(UpdateBarcodeEvent(barcode: result));
    }
  }
}
