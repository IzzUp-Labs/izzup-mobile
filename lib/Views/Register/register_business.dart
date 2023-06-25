import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:izzup/Models/autocomplete_address_textfield.dart';
import 'package:izzup/Models/classy_loader.dart';
import 'package:izzup/Models/globals.dart';
import 'package:izzup/Services/colors.dart';
import 'package:izzup/Services/navigation.dart';
import 'package:izzup/Views/Register/register_id_card.dart';
import 'package:izzup/Views/Register/register_success.dart';

import '../../Models/wave.dart';
import '../../Services/api.dart';
import '../../Services/prefs.dart';

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
  bool _isLoading = false;

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

  void modifyRegistrationAccount() {
    Globals.tempEmployer.company.name = _nameController.text;
    Globals.tempEmployer.company.address = _addressController.text;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
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
                    onPressed: () async {
                      if (_validateFields()) {
                        modifyRegistrationAccount();
                        setState(() { _isLoading = true; });
                        if (await Api.registerAndLoginEmployer()) {
                          Prefs.setString('userEmail', Globals.tempEmployer.email);
                          Prefs.setString('userPwd', Globals.tempEmployer.password);
                          if (context.mounted) {
                            context.navigateWithoutBack(const RegisterIdCard());
                          }
                        } else {
                          setState(() { _isLoading = false; });
                        }
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
        ),
        if (_isLoading) const ClassyLoader()
      ],
    );
  }
}
