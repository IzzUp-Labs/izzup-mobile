import 'package:flutter/material.dart';
import 'package:gig/Models/wave.dart';
import 'package:gig/Services/api.dart';
import 'package:gig/Services/colors.dart';
import 'package:gig/Services/navigation.dart';
import 'package:gig/Views/SignIn/signin_status_choice.dart';
import 'package:gig/Views/SignIn/singin_confirm_password.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Models/classy_loader.dart';
import '../../Services/email_validator.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _emailTextFieldController = TextEditingController();
  bool _isValid = true;
  bool _isLoading = false;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _emailTextFieldController.dispose();
    super.dispose();
  }

  Future<void> _validateEmail(String email) async {
    setState(() {
      _isValid = EmailValidator.validate(email);
    });
    if (_isValid) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('signInEmail', email);
      _loadNavigation();
    }
  }

  void _loadNavigation() {
    setState(() {
      context.dropFocus();
      _isLoading = true;
      Api.authCheck(_emailTextFieldController.text).then((value) {
        _isLoading = false;
        if (value == true) {
          context.push(const SignInConfirmPassword());
        } else if (value == false) {
          context.push(const SignInStatusChoice());
        }
      });
    });
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
                    "Let's get to know each other",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 20, top: 20, right: 20),
                  child: Text(
                    "Do you already have an account or want to create one ? Either way enter your email here and we'll do the rest 😉",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, bottom: 20, top: 50),
                  child: TextField(
                    controller: _emailTextFieldController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey)),
                      prefixIcon: const Icon(
                        Icons.email,
                        color: Colors.grey,
                      ),
                      border: const OutlineInputBorder(),
                      labelText: 'Enter your email',
                      labelStyle: const TextStyle(color: Colors.grey),
                      errorText: _isValid ? null : 'Invalid email address',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, bottom: 20, top: 50),
                  child: ElevatedButton(
                    onPressed: () =>
                        _validateEmail(_emailTextFieldController.text),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      minimumSize: const Size(222, 56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30), // <-- Radius
                      ),
                    ),
                    child: const Text(
                      "Next",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
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
