import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:izzup/Services/navigation.dart';
import 'package:izzup/Views/Register/register_id_card.dart';

import '../../Models/autocomplete_address_textfield.dart';
import '../../Models/classy_loader.dart';
import '../../Models/globals.dart';
import '../../Models/wave.dart';
import '../../Services/api.dart';
import '../../Services/colors.dart';

class RegisterExtraAddress extends StatefulWidget {
  const RegisterExtraAddress({super.key});

  @override
  State<RegisterExtraAddress> createState() => _RegisterExtraAddressState();
}

class _RegisterExtraAddressState extends State<RegisterExtraAddress> {
  final _addressController = TextEditingController();
  bool _isLoading = false;
  bool _isAddressValid = true;

  bool _validateFields() {
    setState(() {
      _isAddressValid = true;
    });

    if (_addressController.text.isEmpty) {
      setState(() {
        _isAddressValid = false;
      });
      return false;
    }

    return true;
  }

  void modifyRegistrationAccount() {
    Globals.tempExtra.address = _addressController.text;
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
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    AppLocalizations.of(context)
                            ?.register_tellUsAboutYourself ??
                        "Tell us about your yourself",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    AppLocalizations.of(context)?.register_weNeedYourAddress ??
                        "We need your address to provide you gigs when you don't have location services available",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
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
                        hintText:
                            AppLocalizations.of(context)?.register_address ??
                                'Address',
                        errorText: _isAddressValid
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
                      if (_validateFields()) {
                        modifyRegistrationAccount();
                        setState(() {
                          _isLoading = true;
                        });
                        if (await Api.registerAndLoginExtra()) {
                          Globals.setUserFromExtra();
                          if (context.mounted) {
                            context.navigateWithoutBack(const RegisterIdCard());
                          }
                        } else {
                          setState(() {
                            _isLoading = false;
                          });
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
                    child: Text(
                      AppLocalizations.of(context)?.register_validate ??
                          "Validate",
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w600),
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
