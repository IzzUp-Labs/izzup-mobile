import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:izzup/Models/register_account_type.dart';
import 'package:izzup/Models/wave.dart';
import 'package:izzup/Services/colors.dart';
import 'package:izzup/Services/navigation.dart';
import 'package:izzup/Services/string_to_bool.dart';
import 'package:izzup/Views/Register/register_business.dart';
import 'package:izzup/Views/Register/register_extra_address.dart';

import '../../Models/globals.dart';

class RegisterInformations extends StatefulWidget {
  const RegisterInformations({super.key, required this.accountType});

  final RegisterAccountType accountType;

  @override
  State<RegisterInformations> createState() => _RegisterInformationsState();
}

class _RegisterInformationsState extends State<RegisterInformations> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _dateController = TextEditingController();

  bool _isFirstNameValid = true;
  bool _isLastNameValid = true;
  bool _isDateValid = true;

  DateTime? pickedDate;

  bool _isLoading = false;

  bool _validateFields() {
    setState(() {
      _isFirstNameValid = true;
      _isLastNameValid = true;
      _isDateValid = true;
    });
    bool isErrored = false;
    if (_firstNameController.text.length < 2) {
      setState(() {
        _isFirstNameValid = false;
      });
      isErrored = true;
    }
    if (_lastNameController.text.length < 2) {
      setState(() {
        _isLastNameValid = false;
      });
      isErrored = true;
    }

    if (pickedDate == null) {
      setState(() {
        _isDateValid = false;
      });
      isErrored = true;
    } else {
      DateTime adultDate = DateTime(
        pickedDate!.year + 18,
        pickedDate!.month,
        pickedDate!.day,
      );

      if (!adultDate.isBefore(DateTime.now())) {
        setState(() {
          _isDateValid = false;
        });
        isErrored = true;
      }
    }

    return isErrored;
  }

  void modifyRegistrationAccount() {
    if (widget.accountType == RegisterAccountType.jobSeeker) {
      Globals.tempExtra.firstName = _firstNameController.text;
      Globals.tempExtra.lastName = _lastNameController.text;
      Globals.tempExtra.dateOfBirth = _dateController.text.ddMmYyyyToDateTime;
    } else {
      Globals.tempEmployer.firstName = _firstNameController.text;
      Globals.tempEmployer.lastName = _lastNameController.text;
      Globals.tempEmployer.dateOfBirth =
          _dateController.text.ddMmYyyyToDateTime;
    }
  }

  Future<void> pushNextScreen() async {
    modifyRegistrationAccount();
    if (widget.accountType == RegisterAccountType.jobSeeker) {
      if (context.mounted) {
        context.navigateWithoutBack(const RegisterExtraAddress());
      }
    } else {
      if (context.mounted) context.push(const RegisterBusiness());
    }
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
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                AppLocalizations.of(context)?.register_tellUsAboutYourself ??
                    "Tell us about yourself",
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 10, right: 20),
              child: Text(
                widget.accountType == RegisterAccountType.jobSeeker
                    ? AppLocalizations.of(context)
                            ?.register_theseWillBeDisplayedOnYourProfile ??
                        "These will be displayed on your profile as your informations. Don't worry you can always change them later !"
                    : AppLocalizations.of(context)
                            ?.register_theseWillBeDisplayedOnTheCompanyPage ??
                        "These will be displayed on the company page as the owner informations. Don't worry you can always change them later !",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 20, right: 20, bottom: 10, top: 50),
              child: TextField(
                controller: _firstNameController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.person,
                    color: Colors.grey,
                  ),
                  focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
                  border: const OutlineInputBorder(),
                  hintText: AppLocalizations.of(context)
                          ?.register_enterYourFirstName ??
                      'Enter your first name',
                  errorText: _isFirstNameValid
                      ? null
                      : AppLocalizations.of(context)
                              ?.register_invalidFirstName ??
                          'Invalid first name',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 10, bottom: 10, left: 20, right: 20),
              child: TextField(
                controller: _lastNameController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.person,
                    color: Colors.grey,
                  ),
                  focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
                  border: const OutlineInputBorder(),
                  hintText: AppLocalizations.of(context)
                          ?.register_enterYourLastName ??
                      'Enter your last name',
                  errorText: _isLastNameValid
                      ? null
                      : AppLocalizations.of(context)
                              ?.register_invalidLastName ??
                          'Invalid last name',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 10, bottom: 10, left: 20, right: 20),
              child: TextField(
                controller: _dateController,
                decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.calendar_month,
                      color: Colors.grey,
                    ),
                    focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
                    border: const OutlineInputBorder(),
                    hintText: AppLocalizations.of(context)
                            ?.register_enterYourDateOfBirth ??
                        'Enter your date of birth',
                    errorText: _isDateValid
                        ? null
                        : AppLocalizations.of(context)?.register_youMustBe18 ??
                            "You must be 18 years old to use the service."),
                readOnly: true,
                onTap: () async {
                  pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    //get today's date
                    firstDate: DateTime(1900),
                    //DateTime.now() - not to allow to choose before today.
                    lastDate: DateTime.now(),
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: const ColorScheme.light(
                            primary: AppColors.accent,
                            // header background color
                            onPrimary: Colors.white,
                            // header text color
                            onSurface: AppColors.accent, // body text color
                          ),
                          textButtonTheme: TextButtonThemeData(
                            style: TextButton.styleFrom(
                              foregroundColor:
                                  AppColors.accent, // button text color
                            ),
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _dateController.text = DateFormat('dd/MM/yyyy').format(
                          pickedDate!); //set formatted date to TextField value.
                    });
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
              child: ElevatedButton(
                onPressed: () {
                  if (!_validateFields()) {
                    pushNextScreen();
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
                  AppLocalizations.of(context)?.register_next ?? "Next",
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const Spacer(),
            const Expanded(child: Wave()),
          ],
        ),
      ),
    );
  }
}
