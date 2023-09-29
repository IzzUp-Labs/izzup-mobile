import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:izzup/Models/autocomplete_address_textfield.dart';
import 'package:izzup/Models/classy_loader.dart';
import 'package:izzup/Models/globals.dart';
import 'package:izzup/Services/colors.dart';
import 'package:izzup/Views/Register/register_select_place.dart';

import '../../Models/wave.dart';
import '../../Services/api.dart';

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
  bool _noPlaceFound = false;

  bool _validateFields() {
    setState(() {
      _isNameValid = true;
      _isAddressValid = true;
      _noPlaceFound = false;
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

  _onValidatePressed() async {
    if (_validateFields()) {
      modifyRegistrationAccount();
      setState(() {
        _isLoading = true;
      });
      final place =
          await Api.getPlace(_nameController.text, _addressController.text);
      if (place != null) {
        final placePhotoLinks = await Api.getPlacePhotoLinks(place.placeId);
        if (context.mounted) {
          Navigator.of(context)
              .push(RegisterSelectPlaceRoute(place, placePhotoLinks));
        }
      } else {
        setState(() {
          _noPlaceFound = true;
        });
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            bottom: false,
            child: Stack(
              children: [
                SingleChildScrollView(
                  reverse: true,
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
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          AppLocalizations.of(context)
                                  ?.register_tellUsAboutYourBusiness ??
                              "Tell us about your business",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 32, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          AppLocalizations.of(context)
                                  ?.register_theseInformationsWillBeDisplayed ??
                              "These informations will be displayed on the company profile",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
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
                              errorMaxLines: 2,
                              hintText: AppLocalizations.of(context)
                                      ?.register_nameOfThePlace ??
                                  'Name of the place',
                              errorText: _noPlaceFound
                                  ? AppLocalizations.of(context)
                                          ?.register_noPlaceFound ??
                                      "We did not found a place matching this address and name."
                                  : _isNameValid
                                      ? null
                                      : AppLocalizations.of(context)
                                              ?.register_pleaseProvideAName ??
                                          "Please provide a name."),
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
                              errorMaxLines: 2,
                              hintText: AppLocalizations.of(context)
                                      ?.register_address ??
                                  'Address',
                              errorText: _noPlaceFound
                                  ? AppLocalizations.of(context)
                                          ?.register_noPlaceFound ??
                                      "We did not found a place matching this address and name."
                                  : _isAddressValid
                                      ? null
                                      : AppLocalizations.of(context)
                                              ?.register_pleaseEnterAnAddress ??
                                          "Please enter an address."),
                          getPlaceDetailCallback: (Prediction prediction) {
                            // this method will return latlng with place detail
                            if (kDebugMode) {
                              print("${prediction.lat} ${prediction.lng}");
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20, right: 20, bottom: 20, top: 50),
                        child: ElevatedButton(
                          onPressed: () async {
                            _onValidatePressed();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.accent,
                            minimumSize: const Size(222, 56),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(30), // <-- Radius
                            ),
                          ),
                          child: Text(
                            AppLocalizations.of(context)?.register_validate ??
                                "Validate",
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.only(
                              bottom:
                              MediaQuery.of(context).viewInsets.bottom)),
                    ],
                  ),
                ),
                const Column(
                  children: [
                    Spacer(),
                    Wave(),
                  ],
                ),
                if (_isLoading) ClassyLoader(loaderSize: MediaQuery.of(context).size.height)
              ],
            ),
          ),
        ),
      ],
    );
  }
}
