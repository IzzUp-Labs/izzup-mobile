import 'package:flutter/material.dart';
import 'package:gig/Models/wave.dart';
import 'package:gig/Services/colors.dart';
import 'package:gig/Services/navigation.dart';
import 'package:gig/Views/SignIn/signin_status_choice.dart';

class SignInConfirmPassword extends StatefulWidget {
  const SignInConfirmPassword({super.key});

  @override
  State<SignInConfirmPassword> createState() => _SignInConfirmPasswordState();
}

class _SignInConfirmPasswordState extends State<SignInConfirmPassword> {
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
                "Hi ! Welcome back !",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
            ),
            const Padding(
              padding:
                  EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 50),
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.email,
                    color: Colors.grey,
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
                  border: OutlineInputBorder(),
                  hintText: 'Enter your password',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 20, right: 20, bottom: 20, top: 50),
              child: ElevatedButton(
                onPressed: () {
                  context.push(const SignInStatusChoice());
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
    );
  }
}
