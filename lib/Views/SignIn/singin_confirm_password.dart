import 'package:flutter/material.dart';
import 'package:izzup/Models/classy_loader.dart';
import 'package:izzup/Models/globals.dart';
import 'package:izzup/Models/wave.dart';
import 'package:izzup/Services/api.dart';
import 'package:izzup/Services/colors.dart';
import 'package:izzup/Services/navigation.dart';
import 'package:izzup/Services/prefs.dart';
import 'package:izzup/Views/Home/home.dart';
import 'package:izzup/Views/SignIn/signin_status_choice.dart';

class SignInConfirmPassword extends StatefulWidget {
  const SignInConfirmPassword({super.key});

  @override
  State<SignInConfirmPassword> createState() => _SignInConfirmPasswordState();
}

class _SignInConfirmPasswordState extends State<SignInConfirmPassword> {
  final _pwdController = TextEditingController();

  bool _isPwdValid = true;
  bool _isLoading = false;

  void _validateFields() async {
    setState(() {
      _isLoading = true;
      _isPwdValid = true;
    });
    Globals.tempExtra.password = _pwdController.text;
    Globals.setUserFromExtra();
    var loginSuccess = await Api.login(Globals.tempExtra);
    setState(() { _isLoading = false; });
    if (loginSuccess) {
      if (context.mounted) context.navigateWithoutBack(const Home());
    } else {
      setState(() { _isPwdValid = false; });
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
                    "Hi ! Welcome back !",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 20, top: 20, right: 20),
                  child: Text(
                    "We found your account ! All you have to do now is enter your password 🫡",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                Padding(
                  padding:
                  const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 50),
                  child: TextField(
                    controller: _pwdController,
                    obscureText: true,
                    decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.email,
                          color: Colors.grey,
                        ),
                        focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey)),
                        border: const OutlineInputBorder(),
                        hintText: 'Enter your password',
                        errorText: _isPwdValid ? null : 'Password not recognized'
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, bottom: 20, top: 50),
                  child: ElevatedButton(
                    onPressed: () {
                      _validateFields();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      minimumSize: const Size(222, 56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30), // <-- Radius
                      ),
                    ),
                    child: const Text(
                      "Next",
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
