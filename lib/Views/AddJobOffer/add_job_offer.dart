import 'dart:async';

import 'package:flutter/material.dart';
import 'package:izzup/Models/job_offer.dart';
import 'package:izzup/Services/api.dart';
import 'package:izzup/Views/Popups/success.dart';

import '../../Models/classy_loader.dart';
import '../../Models/wave.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../Services/colors.dart';

class AddJobOffer extends StatefulWidget {
  AddJobOffer({super.key, required this.userId, required this.companyId});

  final int userId;
  final int companyId;

  @override
  State<AddJobOffer> createState() => _AddJobOfferState();
}

class _AddJobOfferState extends State<AddJobOffer> {
  final _titleController = TextEditingController();
  final _hourlyRateController = TextEditingController();
  final _numberOfSpotsController = TextEditingController();

  bool _isTitleValid = true;
  bool _isHourlyRateValid = true;
  bool _isNumberOfSpotsValid = true;
  bool _hourlyRateisZero = false;
  bool _spotsIsZero = false;

  bool _isLoading = false;
  bool _success = false;

  bool _areFieldsValid() {
    setState(() {
      _isTitleValid = true;
      _isHourlyRateValid = true;
      _isNumberOfSpotsValid = true;
      _hourlyRateisZero = false;
      _spotsIsZero = false;
    });

    var areFieldsValid = true;

    if (_titleController.text.isEmpty) {
      setState(() {
        _isTitleValid = false;
      });
      areFieldsValid = false;
    }
    if (_hourlyRateController.text.isEmpty) {
      setState(() {
        _isHourlyRateValid = false;
      });
      areFieldsValid = false;
    }
    if (_numberOfSpotsController.text.isEmpty) {
      setState(() {
        _isNumberOfSpotsValid = false;
      });
      areFieldsValid = false;
    }
    if (_hourlyRateController.text == '0') {
      setState(() {
        _hourlyRateisZero = true;
      });
      areFieldsValid = false;
    }
    if (_numberOfSpotsController.text == '0') {
      setState(() {
        _spotsIsZero = true;
      });
      areFieldsValid = false;
    }

    return areFieldsValid;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Scaffold(
              body: SingleChildScrollView(
                child: Column(
                    children: [
                      Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back, color: AppColors.accent),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                            const Spacer(),
                          ]
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top:20),
                        child: Text(
                          AppLocalizations.of(context)?.createJobOffer_title ??
                              'Create a job offer',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: TextField(
                          controller: _titleController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey)),
                            prefixIcon: const Icon(
                              Icons.title,
                              color: Colors.grey,
                            ),
                            border: const OutlineInputBorder(),
                            labelText:
                            AppLocalizations.of(context)?.createJobOffer_jobTitle ??
                                'Job title',
                            labelStyle: const TextStyle(color: Colors.grey),
                            errorText: _isTitleValid
                                ? null
                                : AppLocalizations.of(context)
                                ?.createJobOffer_invalidTitle ??
                                'Invalid title',
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            height: 100,
                            width: MediaQuery.of(context).size.width / 2 - 30,
                            child: TextField(
                              controller: _hourlyRateController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                errorMaxLines: 3,
                                focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey)),
                                prefixIcon: const Icon(
                                  Icons.euro,
                                  color: Colors.grey,
                                ),
                                border: const OutlineInputBorder(),
                                labelText:
                                AppLocalizations.of(context)?.createJobOffer_hourlyRate ??
                                    'Hourly rate',
                                labelStyle: const TextStyle(color: Colors.grey),
                                errorText: _isHourlyRateValid
                                    ? _hourlyRateisZero ? AppLocalizations.of(context)?.createJobOffer_hourlyRateCantBeZero ?? "Hourly rate can't be zero" : null
                                    : AppLocalizations.of(context)?.createJobOffer_invalidHourlyRate ?? 'Invalid hourly rate',
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 100,
                            width: MediaQuery.of(context).size.width / 2 - 30,
                            child: TextField(
                              controller: _numberOfSpotsController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                errorMaxLines: 3,
                                focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey)),
                                prefixIcon: const Icon(
                                  Icons.person_4,
                                  color: Colors.grey,
                                ),
                                border: const OutlineInputBorder(),
                                labelText:
                                AppLocalizations.of(context)?.createJobOffer_numberOfSpots ??
                                    'Number of spots',
                                labelStyle: const TextStyle(color: Colors.grey),
                                errorText: _isNumberOfSpotsValid
                                    ? _spotsIsZero ? AppLocalizations.of(context)?.createJobOffer_spotsCantBeZero ?? "Spots can't be zero"  : null
                                    : AppLocalizations.of(context)
                                    ?.createJobOffer_invalidNumberOfSpots ??
                                    'Invalid title',
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_areFieldsValid()) {
                              setState(() {
                                _isLoading = true;
                              });
                              if (await Api.uploadJobOffer(
                                  widget.userId,
                                  widget.companyId,
                                  JobOffer(
                                      _titleController.text,
                                      int.parse(_hourlyRateController.text),
                                      true,
                                      int.parse(_numberOfSpotsController.text),
                                      0
                                  )
                              )){
                                setState(() {
                                  _success = true;
                                });
                                Timer(const Duration(seconds: 1), () {
                                  Navigator.pop(context);
                                });
                              } else {
                                setState(() {
                                  _success = false;
                                });
                              }
                              setState(() {
                                _isLoading = false;
                              });
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
                            AppLocalizations.of(context)?.createJobOffer_create ?? "Create",
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      Image(
                        height: MediaQuery.of(context).size.height * 0.3,
                        image: const AssetImage('assets/we_are_hiring.png'),
                      ),
                      const SizedBox(height: 50)
                    ]
                ),
              ),
            ),
            const Column(
              children: [
                Spacer(),
                Wave()
              ],
            ),
            if(_isLoading) const ClassyLoader(),
            if(_success) const SuccessPopup()
          ],
        )
    );
  }
}
