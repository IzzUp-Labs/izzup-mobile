import 'package:flutter/material.dart';
import 'package:izzup/Services/colors.dart';
import 'package:izzup/Services/navigation.dart';
import 'package:izzup/Views/Register/register_account.dart';
import 'package:izzup/Views/Register/register_account_type.dart';

class SignInStatusChoice extends StatefulWidget {
  const SignInStatusChoice({super.key});

  @override
  State<SignInStatusChoice> createState() => _SignInStatusChoiceState();
}

class _SignInStatusChoiceState extends State<SignInStatusChoice> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Center(
                    child:ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: const Image(
                        image: AssetImage('assets/logo.png'),
                        width: 70,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const Column(
              children: [
                Image(
                  image: AssetImage('assets/magnifier_green_wave.png'),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  SizedBox(
                    height: (MediaQuery.of(context).size.height / 2) -  MediaQuery.of(context).padding.top + 10,
                    width: MediaQuery.of(context).size.width,
                  ),
                  Row(
                    children: [
                      Text(
                        "Continue as",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: MediaQuery.of(context).size.height / 30),
                      ),
                      const Spacer()
                    ],
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 30, bottom: 10),
                      child: ElevatedButton(
                        onPressed: () => context.push(const RegisterAccount(
                            accountType: RegisterAccountType.jobSeeker)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          fixedSize: Size(
                              MediaQuery.of(context).size.width / 3 * 2,
                              MediaQuery.of(context).size.height / 7
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10), // <-- Radius
                          ),
                        ),
                        child: Row(
                          children: [
                            Image(
                              image: const AssetImage('assets/job_hunter.png'),
                              height: MediaQuery.of(context).size.width / 8,
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
                                        fontSize: MediaQuery.of(context).size.height / 35),
                                  ),
                                  Text(
                                    "You are looking for gigs",
                                    style: TextStyle(
                                        color: AppColors.accent, fontSize: MediaQuery.of(context).size.height / 60),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: ElevatedButton(
                        onPressed: () => context.push(const RegisterAccount(
                            accountType: RegisterAccountType.company)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          fixedSize: Size(
                              MediaQuery.of(context).size.width / 3 * 2,
                              MediaQuery.of(context).size.height / 7
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10), // <-- Radius
                          ),
                        ),
                        child: Row(
                          children: [
                            Image(
                              image: const AssetImage('assets/work_time.png'),
                              height: MediaQuery.of(context).size.width / 8,
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
                                        fontSize: MediaQuery.of(context).size.height / 35),
                                  ),
                                  Text(
                                    "You want to find people to work in your establishment",
                                    style: TextStyle(
                                      color: AppColors.accent,
                                      fontSize: MediaQuery.of(context).size.height / 60,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
