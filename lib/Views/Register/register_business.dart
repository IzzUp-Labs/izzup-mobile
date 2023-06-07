import 'package:flutter/material.dart';
import 'package:gig/Models/autocomplete_address_textfield.dart';
import 'package:gig/Services/colors.dart';
import 'package:gig/Services/navigation.dart';
import 'package:gig/Views/Register/register_success.dart';
import 'package:google_places_flutter/model/prediction.dart';

import '../../Models/wave.dart';

class RegisterBusiness extends StatefulWidget {
  const RegisterBusiness({super.key});

  @override
  State<RegisterBusiness> createState() => _RegisterBusinessState();
}

class _RegisterBusinessState extends State<RegisterBusiness> {
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();

  bool _isNameValid = true;
  bool _isAddressValid = true;

  bool _validateFields() {
    setState(() {
      _isNameValid = true;
      _isAddressValid = true;
    });

    bool noErrors = true;
    if (_nameController.text.isEmpty) {
      setState(() {
        _isNameValid = false;
      });
      noErrors = false;
    }
    if (_addressController.text.isEmpty) {
      setState(() {
        _isAddressValid = false;
      });
      noErrors = false;
    }
    return noErrors;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: const Image(
                  image: AssetImage('assets/logo.png'),
                  width: 70,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                "Tell us about your business",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                "These informations will be displayed on the company profile",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 20, bottom: 10, left: 20, right: 20),
              child: TextField(
                controller: _nameController,
                decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.storefront,
                      color: Colors.grey,
                    ),
                    focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
                    border: const OutlineInputBorder(),
                    hintText: 'Name of the place',
                    errorText: _isNameValid ? null : "Please provide a name."),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: AutocompleteAddressTextfield(
                addressController: _addressController,
                inputDecoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.pin_drop,
                      color: Colors.grey,
                    ),
                    focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
                    border: const OutlineInputBorder(),
                    hintText: 'Address',
                    errorText:
                        _isAddressValid ? null : "Please enter an address."),
                getPlaceDetailCallback: (Prediction prediction) {
                  // this method will return latlng with place detail
                  print("${prediction.lat} ${prediction.lng}");
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 20, right: 20, bottom: 20, top: 50),
              child: ElevatedButton(
                onPressed: () {
                  if (_validateFields()) {
                    context.navigateWithoutBack(const RegisterSuccess());
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  minimumSize: const Size(222, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // <-- Radius
                  ),
                ),
                child: const Text(
                  "Validate",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const Spacer(),
            const Wave(),
          ],
        ),
      ),
    );
  }
}
