import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';
import 'package:izzup/Models/globals.dart';
import 'package:izzup/Models/register_account_type.dart';
import 'package:izzup/Services/colors.dart';
import 'package:izzup/Services/navigation.dart';
import 'package:izzup/Views/Register/register_informations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Models/wave.dart';

class RegisterAccount extends StatefulWidget {
  const RegisterAccount({super.key, required this.accountType});

  final RegisterAccountType accountType;

  @override
  State<RegisterAccount> createState() => _RegisterAccountState();
}

class _RegisterAccountState extends State<RegisterAccount> {
  final _emailTextFieldController = TextEditingController();
  final _passwordTFC = TextEditingController();

  var _passwordVisible = false;
  var _isPasswordValid = false;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _emailTextFieldController.dispose();
    _passwordTFC.dispose();
    super.dispose();
  }

  void setEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _emailTextFieldController.text = prefs.getString("signInEmail") ?? "";
  }

  void modifyRegistrationAccount() {
    if (widget.accountType == RegisterAccountType.jobSeeker) {
      Globals.tempExtra.email = _emailTextFieldController.text;
      Globals.tempExtra.password = _passwordTFC.text;
    } else {
      Globals.tempEmployer.email = _emailTextFieldController.text;
      Globals.tempEmployer.password = _passwordTFC.text;
    }
  }

  @override
  void initState() {
    setEmail();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            SingleChildScrollView(
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
                      AppLocalizations.of(context)?.register_niceToMeetYou ??
                          "Nice to meet you !",
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
                          ?.register_toBeginWithRegistration ??
                          "To begin with the registration we will just need a contact email and a password for your account"
                          : AppLocalizations.of(context)
                          ?.register_toBeginWithRegistrationCompany ??
                          "To begin with the registration we will just need a contact email and a password for the account linked to your business",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, bottom: 10, top: 20),
                    child: TextField(
                      scrollPadding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                      controller: _emailTextFieldController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.email,
                          color: Colors.grey,
                        ),
                        focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey)),
                        border: const OutlineInputBorder(),
                        hintText:
                        AppLocalizations.of(context)?.register_enterYourEmail ??
                            'Enter your email',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, bottom: 10, top: 10),
                    child: Column(
                      children: [
                        TextField(
                          scrollPadding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                          controller: _passwordTFC,
                          obscureText: !_passwordVisible,
                          decoration: InputDecoration(
                            labelStyle: const TextStyle(fontFamily: 'Roboto'),
                            prefixIcon: const Icon(
                              Icons.password,
                              color: Colors.grey,
                            ),
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey)),
                            border: const OutlineInputBorder(),
                            hintText: AppLocalizations.of(context)
                                ?.register_enterYourPassword ??
                                'Enter your password',
                            suffixIcon: IconButton(
                              icon: Icon(
                                _passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Theme.of(context).primaryColorDark,
                              ),
                              onPressed: () {
                                setState(() {
                                  _passwordVisible = !_passwordVisible;
                                });
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          child: FlutterPwValidator(
                              controller: _passwordTFC,
                              minLength: 8,
                              numericCharCount: 2,
                              uppercaseCharCount: 1,
                              specialCharCount: 1,
                              width: 400,
                              height: 125,
                              successColor: AppColors.accent,
                              failureColor: Colors.deepOrange,
                              onSuccess: () {
                                setState(() {
                                  _isPasswordValid = true;
                                });
                              },
                              onFail: () {
                                setState(() {
                                  _isPasswordValid = false;
                                });
                              }),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: ElevatedButton(
                      onPressed: !_isPasswordValid
                          ? null
                          : () {
                        modifyRegistrationAccount();
                        context.push(RegisterInformations(
                            accountType: widget.accountType));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        minimumSize: const Size(222, 56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30), // <-- Radius
                        ),
                      ),
                      child: Text(
                        AppLocalizations.of(context)?.register_continue ?? "Continue",
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom))
                ],
              ),
            ),
            const Column(
              children: [
                Spacer(),
                Wave(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
