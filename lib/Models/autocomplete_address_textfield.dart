import 'package:flutter/material.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';

class AutocompleteAddressTextfield extends StatelessWidget {
  final TextEditingController addressController;
  final InputDecoration inputDecoration;
  final Function(Prediction) getPlaceDetailCallback;

  const AutocompleteAddressTextfield(
      {super.key,
      required this.addressController,
      required this.inputDecoration,
      required this.getPlaceDetailCallback});

  @override
  Widget build(BuildContext context) {
    return GooglePlaceAutoCompleteTextField(
      textEditingController: addressController,
      googleAPIKey: "AIzaSyDh1zb9PJZl-C_bqZNzg-oNhGXfdy2Z5pc",
      inputDecoration: inputDecoration,
      debounceTime: 400,
      // default 600 ms,
      countries: const ["fr"],
      // optional by default null is set
      isLatLngRequired: true,
      // if you required coordinates from place detail
      getPlaceDetailWithLatLng: getPlaceDetailCallback,
      // this callback is called when isLatLngRequired is true
      itemClick: (Prediction prediction) {
        addressController.text = prediction.description ?? "";
        addressController.selection = TextSelection.fromPosition(
            TextPosition(offset: prediction.description?.length ?? 0));
      },
    );
  }
}
