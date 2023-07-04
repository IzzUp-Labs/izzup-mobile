import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:izzup/Models/job_offer.dart';
import 'package:izzup/Services/api.dart';
import 'package:izzup/Views/Popups/success.dart';
import 'package:textfield_datepicker/textfield_dateAndTimePicker.dart';

import '../../Models/classy_loader.dart';
import '../../Models/wave.dart';
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
  final _startTimeController = TextEditingController();
  final _hoursWorkedController = TextEditingController();
  final _descriptionController = TextEditingController();

  DateTime? _pickedDate;

  bool _isTitleValid = true;
  bool _isHourlyRateValid = true;
  bool _isNumberOfSpotsValid = true;
  bool _hourlyRateisZero = false;
  bool _spotsIsZero = false;
  bool _isStartTimeValid = true;
  bool _isHoursWorkedValid = true;
  bool _isDescriptionValid = true;

  bool _isLoading = false;
  bool _success = false;

  bool _areFieldsValid() {
    setState(() {
      _isTitleValid = true;
      _isHourlyRateValid = true;
      _isNumberOfSpotsValid = true;
      _hourlyRateisZero = false;
      _spotsIsZero = false;
      _isStartTimeValid = true;
      _isHoursWorkedValid = true;
      _isDescriptionValid = true;
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
    if (_startTimeController.text.isEmpty) {
      setState(() {
        _isStartTimeValid = false;
      });
      areFieldsValid = false;
    } else {
      _pickedDate = DateFormat('dd/MM HH:mm').parse(_startTimeController.text);
      _pickedDate = DateTime(DateTime.now().year, _pickedDate!.month, _pickedDate!.day, _pickedDate!.hour, _pickedDate!.minute);
    }
    if (_hoursWorkedController.text.isEmpty) {
      setState(() {
        _isHoursWorkedValid = false;
      });
      areFieldsValid = false;
    }
    if (_descriptionController.text.isEmpty) {
      setState(() {
        _isDescriptionValid = false;
      });
      areFieldsValid = false;
    }

    return areFieldsValid;
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back,
                              color: AppColors.accent),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        const Spacer(),
                      ]),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
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
                        padding:
                        const EdgeInsets.only(left: 20, right: 20, top: 20),
                        child: TextField(
                          controller: _titleController,
                          decoration: InputDecoration(
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey)),
                            prefixIcon: const Icon(
                              Icons.title,
                              color: Colors.grey,
                            ),
                            border: const OutlineInputBorder(),
                            labelText: AppLocalizations.of(context)
                                ?.createJobOffer_jobTitle ??
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
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Row(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 2 - 30,
                              child: TextField(
                                controller: _hourlyRateController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  errorMaxLines: 3,
                                  focusedBorder: const OutlineInputBorder(
                                      borderSide:
                                      BorderSide(color: Colors.grey)),
                                  prefixIcon: const Icon(
                                    Icons.euro,
                                    color: Colors.grey,
                                  ),
                                  border: const OutlineInputBorder(),
                                  labelText: AppLocalizations.of(context)
                                      ?.createJobOffer_hourlyRate ??
                                      'Hourly rate',
                                  labelStyle:
                                  const TextStyle(color: Colors.grey),
                                  errorText: _isHourlyRateValid
                                      ? _hourlyRateisZero
                                      ? AppLocalizations.of(context)
                                      ?.createJobOffer_hourlyRateCantBeZero ??
                                      "Hourly rate can't be zero"
                                      : null
                                      : AppLocalizations.of(context)
                                      ?.createJobOffer_invalidHourlyRate ??
                                      'Invalid hourly rate',
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 2 - 30,
                              child: TextField(
                                controller: _numberOfSpotsController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  errorMaxLines: 3,
                                  focusedBorder: const OutlineInputBorder(
                                      borderSide:
                                      BorderSide(color: Colors.grey)),
                                  prefixIcon: const Icon(
                                    Icons.person_4,
                                    color: Colors.grey,
                                  ),
                                  border: const OutlineInputBorder(),
                                  labelText: AppLocalizations.of(context)
                                      ?.createJobOffer_numberOfSpots ??
                                      'Number of spots',
                                  labelStyle:
                                  const TextStyle(color: Colors.grey),
                                  errorText: _isNumberOfSpotsValid
                                      ? _spotsIsZero
                                      ? AppLocalizations.of(context)
                                      ?.createJobOffer_spotsCantBeZero ??
                                      "Spots can't be zero"
                                      : null
                                      : AppLocalizations.of(context)
                                      ?.createJobOffer_invalidNumberOfSpots ??
                                      'Invalid number of spots',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Row(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 2 - 30,
                              child: TextfieldDateAndTimePicker(
                                cupertinoDatePickerBackgroundColor:
                                null,
                                cupertinoDatePickerMaximumDate:
                                DateTime(DateTime.now().year, 12, 31),
                                cupertinoDatePickerMaximumYear:
                                DateTime.now().year + 1,
                                cupertinoDatePickerMinimumYear:
                                DateTime.now().year,
                                cupertinoDatePickerMinimumDate:
                                DateTime(DateTime.now().year),
                                cupertinoDateInitialDateTime: DateTime.now(),
                                materialDatePickerFirstDate:
                                DateTime(DateTime.now().year),
                                materialDatePickerInitialDate: DateTime.now(),
                                materialDatePickerLastDate:
                                DateTime(DateTime.now().year, 12, 31),
                                preferredDateFormat: DateFormat('dd/MM'),
                                materialTimePickerUse24hrFormat: true,
                                cupertinoTimePickerMinuteInterval: 1,
                                cupertinoTimePickerUse24hFormat: true,
                                textfieldDateAndTimePickerController:
                                _startTimeController,
                                textCapitalization:
                                TextCapitalization.sentences,
                                decoration: InputDecoration(
                                  errorMaxLines: 3,
                                  focusedBorder: const OutlineInputBorder(
                                      borderSide:
                                      BorderSide(color: Colors.grey)),
                                  prefixIcon: const Icon(
                                    Icons.access_time,
                                    color: Colors.grey,
                                  ),
                                  border: const OutlineInputBorder(),
                                  labelText: AppLocalizations.of(context)
                                      ?.createJobOffer_startTime ??
                                      'Start time',
                                  labelStyle:
                                  const TextStyle(color: Colors.grey),
                                  errorText: _isStartTimeValid
                                      ? null
                                      : AppLocalizations.of(context)
                                      ?.createJobOffer_invalidStartTime ??
                                      'Invalid start time',
                                ),
                                materialInitialTime: TimeOfDay.now(),
                                materialDatePickerBuilder: (context, child) {
                                  return Theme(
                                    data: Theme.of(context).copyWith(
                                      colorScheme: const ColorScheme.light(
                                        primary: AppColors.accent,
                                        // header background color
                                        onPrimary: Colors.white,
                                        // header text color
                                        onSurface:
                                        AppColors.accent, // body text color
                                      ),
                                      textButtonTheme: TextButtonThemeData(
                                        style: TextButton.styleFrom(
                                          foregroundColor: AppColors
                                              .accent, // button text color
                                        ),
                                      ),
                                    ),
                                    child: child!,
                                  );
                                },
                                materialTimePickerBuilder: (context, child) {
                                  return Theme(
                                    data: Theme.of(context).copyWith(
                                      colorScheme: const ColorScheme.light(
                                        primary: AppColors.accent,
                                        // header background color
                                        onPrimary: Colors.white,
                                        // header text color
                                        onSurface:
                                        AppColors.accent, // body text color
                                      ),
                                      textButtonTheme: TextButtonThemeData(
                                        style: TextButton.styleFrom(
                                          foregroundColor: AppColors
                                              .accent, // button text color
                                        ),
                                      ),
                                    ),
                                    child: child!,
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 20),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 2 - 30,
                              child: TextField(
                                controller: _hoursWorkedController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  errorMaxLines: 3,
                                  focusedBorder: const OutlineInputBorder(
                                      borderSide:
                                      BorderSide(color: Colors.grey)),
                                  prefixIcon: const Icon(
                                    Icons.timelapse,
                                    color: Colors.grey,
                                  ),
                                  border: const OutlineInputBorder(),
                                  labelText: AppLocalizations.of(context)
                                      ?.createJobOffer_hoursWorked ??
                                      'Hours worked',
                                  labelStyle:
                                  const TextStyle(color: Colors.grey),
                                  errorText: _isHoursWorkedValid
                                      ? null
                                      : AppLocalizations.of(context)
                                      ?.createJobOffer_invalidHoursWorked ??
                                      'Invalid number of hours worked',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: TextField(
                          controller: _descriptionController,
                          keyboardType: TextInputType.multiline,
                          minLines: 4,
                          maxLines: null,
                          decoration: InputDecoration(
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey)),
                            prefixIcon: const Icon(
                              Icons.description,
                              color: Colors.grey,
                            ),
                            border: const OutlineInputBorder(),
                            labelText: AppLocalizations.of(context)
                                ?.createJobOffer_description ??
                                'Description',
                            labelStyle: const TextStyle(color: Colors.grey),
                            errorText: _isDescriptionValid
                                ? null
                                : AppLocalizations.of(context)
                                ?.createJobOffer_invalidDescription ??
                                'Invalid dscription',
                          ),
                        ),
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
                                      _descriptionController.text,
                                      _pickedDate!,
                                      int.parse(_hoursWorkedController.text),
                                      int.parse(_hourlyRateController.text),
                                      true,
                                      int.parse(_numberOfSpotsController.text),
                                      0))) {
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
                              borderRadius:
                              BorderRadius.circular(30), // <-- Radius
                            ),
                          ),
                          child: Text(
                            AppLocalizations.of(context)
                                ?.createJobOffer_create ??
                                "Create",
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      Image(
                        height: MediaQuery.of(context).size.height * 0.3,
                        image: const AssetImage('assets/we_are_hiring.png'),
                      ),
                      const SizedBox(height: 75)
                    ]),
              ),
              const Column(
                children: [Spacer(), Wave()],
              ),
              if (_isLoading) const ClassyLoader(),
              if (_success) const SuccessPopup()
            ],
          )),
    );
  }
}
