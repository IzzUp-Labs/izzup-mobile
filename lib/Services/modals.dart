import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:izzup/Models/user.dart';
import 'package:izzup/Views/Ratings/ratings.dart';
import 'package:izzup/Views/Register/register_id_card.dart';

import '../Models/globals.dart';
import '../Models/job_offer_requests.dart';
import '../Models/scale.dart';
import 'api.dart';
import 'colors.dart';
import 'navigation.dart';

class Modals {
  static Future<T> showModal<T>(WidgetBuilder builder,
      {isDismissible = true}) async {
    final BuildContext? context = Navigation.navigatorKey.currentContext;
    if (context == null) return Future.value(null);
    return await showModalBottomSheet(
      context: context,
      builder: builder,
      isScrollControlled: true,
      isDismissible: isDismissible,
      enableDrag: isDismissible,
    );
  }

  static Future<T> showModalNeedsVerification<T>() async {
    return await showModal(
            (context) => Scaffold(
            body: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          AppLocalizations.of(context)
                              ?.idConfirm_needsVerification ??
                              "We need to verify your identity",
                          maxLines: null,
                          textAlign: TextAlign.center,
                          textScaleFactor: ScaleSize.textScaleFactor(context),
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 50),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 50),
                          child: Image.asset("assets/identity_verification.png", height: 300),
                        ),
                        const SizedBox(height: 50),
                        Text(
                          AppLocalizations.of(context)
                              ?.idConfirm_lessThanHours ??
                              "This typically takes less than 24 hours",
                          maxLines: null,
                          textAlign: TextAlign.center,
                          textScaleFactor: ScaleSize.textScaleFactor(context),
                          style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 24,
                              fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            )),
        isDismissible: false);
  }

  static Future<T> showModalNotValid<T>() async {
    return await showModal(
            (context) => Scaffold(
            body: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(AppLocalizations.of(context)
                            ?.idConfirm_notValid ?? "The ID you provided is not valid",
                          maxLines: null,
                          textAlign: TextAlign.center,
                          textScaleFactor: ScaleSize.textScaleFactor(context),
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 50),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 50),
                          child: Image.asset("assets/computer_error.png", height: 300),
                        ),
                        const SizedBox(height: 50),
                        ElevatedButton(
                            onPressed: () {
                              context.navigateWithoutBack(const RegisterIdCard(wasNotValid: true));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              minimumSize: const Size(150, 60),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100), // <-- Radius
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Text(AppLocalizations.of(context)
                                  ?.register_retake ?? "Re-take",
                                maxLines: null,
                                textAlign: TextAlign.center,
                                textScaleFactor: ScaleSize.textScaleFactor(context),
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            )
                        ),
                      ],
                    ),
                  ),
                )
              ],
            )),
        isDismissible: false);
  }

  static Future<T> showModalNeedsId<T>() async {
    return await showModal(
            (context) => Scaffold(
            body: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(AppLocalizations.of(context)
                            ?.idConfirm_needId ?? "We need your ID to verify your identity",
                          maxLines: null,
                          textAlign: TextAlign.center,
                          textScaleFactor: ScaleSize.textScaleFactor(context),
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 50),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 50),
                          child: Image.asset("assets/identity_card.png", height: 300),
                        ),
                        const SizedBox(height: 50),
                        ElevatedButton(
                            onPressed: () {
                              context.navigateWithoutBack(const RegisterIdCard());
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.accent,
                              minimumSize: const Size(150, 60),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100), // <-- Radius
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Text(AppLocalizations.of(context)
                                  ?.idConfirm_capture ?? "Capture",
                                maxLines: null,
                                textAlign: TextAlign.center,
                                textScaleFactor: ScaleSize.textScaleFactor(context),
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            )
                        ),
                      ],
                    ),
                  ),
                )
              ],
            )),
        isDismissible: false);
  }

  static Future<T> showJobRequestSuccessModal<T>(String jobTitle, DateTime startingDate) async {
    return await showModal(
            (context) => Scaffold(
            body: Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: AppColors.accent,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: <Color>[
                        AppColors.accent,
                        Color(0xFF02c18a),
                      ],
                    ),
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 50,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        AppLocalizations.of(context)
                            ?.jobSuccess_offerAccepted ??
                            "A job offer has been accepted !",
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 100),
                      Text(
                        jobTitle,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        DateFormat('dd/MM - HH:mm')
                            .format(startingDate),
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontStyle: FontStyle.italic),
                      ),
                      const SizedBox(height: 100),
                      ElevatedButton(
                        onPressed: () {
                          context.popToHome();
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppColors.accent,
                            fixedSize: const Size(150, 60),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(30), // <-- Radius
                            )),
                        child: Text(
                          AppLocalizations.of(context)?.jobSuccess_super ??
                              "Great !",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )),
        isDismissible: false);
  }

  static Future<T> showJobEndModalExtra<T>(
      String code, String requestId) async {
    return await showModal(
            (context) => Scaffold(
            body: Stack(
              children: [
                Positioned(
                  top: 20,
                  right: 20,
                  child: IconButton(
                    icon: const Icon(
                      Icons.warning_rounded,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      Api.sendProblem(requestId);
                      context.popToHome();
                    },
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                          height: MediaQuery.of(context).size.height / 3.3),
                      Text(
                        AppLocalizations.of(context)?.jobConfirm_timeToLeave ??
                            "It's time to leave !",
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 30,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        AppLocalizations.of(context)?.jobConfirm_giveCode ??
                            "Give this code to your employer",
                        style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic),
                      ),
                      const SizedBox(height: 75),
                      Text(
                        code,
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 75,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                )
              ],
            )),
        isDismissible: false);
  }

  static Future<T> showJobEndModalEmployer<T>(String requestId, String userId) async {
    var codeController = TextEditingController();
    return await showModal(
            (context) => Scaffold(
            body: GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: Stack(
                children: [
                  Positioned(
                    top: 20,
                    right: 20,
                    child: IconButton(
                      icon: const Icon(
                        Icons.warning_rounded,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        Api.sendProblem(requestId);
                        context.popToHome();
                      },
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                            height: MediaQuery.of(context).size.height / 3.3),
                        Text(
                          AppLocalizations.of(context)?.jobConfirm_goodbye ??
                              "It's time to say goodbye...",
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                          textScaleFactor: ScaleSize.textScaleFactor(context),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          AppLocalizations.of(context)
                              ?.jobConfirm_giveCodeFromEmployee ??
                              "Enter the code provided by your employee",
                          style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic),
                          textScaleFactor: ScaleSize.textScaleFactor(context),
                        ),
                        const SizedBox(height: 75),
                        IntrinsicWidth(
                          stepWidth: MediaQuery.of(context).size.width / 10,
                          child: TextField(
                              controller: codeController,
                              textInputAction: TextInputAction.done,
                              keyboardType:
                              const TextInputType.numberWithOptions(
                                  signed: true),
                              textAlign: TextAlign.center,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  focusedBorder: OutlineInputBorder(),
                                  hintText: "1234",
                                  hintStyle: TextStyle(
                                      color: Colors.grey,
                                      fontStyle: FontStyle.italic)),
                              cursorColor: Colors.black,
                              style: const TextStyle(
                                  fontSize: 75,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(4),
                                FilteringTextInputFormatter.digitsOnly,
                              ]),
                        ),
                        const SizedBox(height: 75),
                        ElevatedButton(
                          onPressed: () async {
                            if (await Api.finishWork(
                                requestId, codeController.text)) {
                              Modals.showRateUser(userId);
                            } else {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            AppLocalizations.of(context)
                                                ?.jobConfirm_wrongCode ??
                                                "Wrong code")));
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  10.0), // Adjust the value to change the corner radius
                            ),
                          ),
                          child: Text(
                            AppLocalizations.of(context)?.home_verifyCode ??
                                'Verify code',
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )),
        isDismissible: false);
  }

  static Future<T> showRateUser<T>(String userId) async {
    return await showModal(
            (context) => RatingScreen(userId: userId),
        isDismissible: false
    );
  }
}
