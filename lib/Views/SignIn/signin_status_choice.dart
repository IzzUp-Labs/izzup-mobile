import 'package:flutter/material.dart';
import 'package:gig/Services/colors.dart';
import 'package:gig/Services/navigation.dart';
import 'package:gig/Views/Register/register_account.dart';
import 'package:gig/Views/Register/register_account_type.dart';

class SignInStatusChoice extends StatefulWidget {
  const SignInStatusChoice({super.key});

  @override
  State<SignInStatusChoice> createState() => _SignInStatusChoiceState();
}

class _SignInStatusChoiceState extends State<SignInStatusChoice> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Image(
            image: AssetImage('assets/magnifier_green_wave.png'),
          ),
          SafeArea(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                      top: 20,
                      bottom: 20,
                      left: (MediaQuery.of(context).size.width - 280) / 2),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: const Image(
                      image: AssetImage('assets/logo.png'),
                      width: 70,
                    ),
                  ),
                ),
                const Spacer(
                  flex: 5,
                ),
                const Padding(
                  padding: EdgeInsets.only(right: 100, bottom: 50),
                  child: Text(
                    "Continue as",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 40),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: 10,
                      bottom: 10,
                      left: (MediaQuery.of(context).size.width - 300) / 2),
                  child: ElevatedButton(
                    onPressed: () => context.push(const RegisterAccount(
                        accountType: RegisterAccountType.jobSeeker)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      fixedSize: const Size(300, 120),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // <-- Radius
                      ),
                    ),
                    child: const Row(
                      children: [
                        Image(
                          image: AssetImage('assets/job_hunter.png'),
                          height: 75,
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Job seeker",
                                style: TextStyle(
                                    color: AppColors.accent,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30),
                              ),
                              Text(
                                "You are looking for gigs",
                                style: TextStyle(
                                    color: AppColors.accent, fontSize: 15),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: 10,
                      bottom: 10,
                      left: (MediaQuery.of(context).size.width - 300) / 2),
                  child: ElevatedButton(
                    onPressed: () => context.push(const RegisterAccount(
                        accountType: RegisterAccountType.company)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      fixedSize: const Size(300, 120),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // <-- Radius
                      ),
                    ),
                    child: const Row(
                      children: [
                        Image(
                          image: AssetImage('assets/work_time.png'),
                          height: 75,
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Company",
                                style: TextStyle(
                                    color: AppColors.accent,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30),
                              ),
                              Text(
                                "You want to find people to work in your establishment",
                                style: TextStyle(
                                  color: AppColors.accent,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(
                  flex: 1,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
