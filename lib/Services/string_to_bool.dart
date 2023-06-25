import 'package:intl/intl.dart';

extension StringBoolean on String {
  bool? toBoolean() {
    return (toLowerCase() == "true" || toLowerCase() == "1")
        ? true
        : (toLowerCase() == "false" || toLowerCase() == "0")
            ? false
            : null;
  }

  DateTime get ddMmYyyyToDateTime => _ddMmYyyyToDateTime();

  DateTime _ddMmYyyyToDateTime() {
    return DateFormat('dd/MM/yyyy').parse(this);
  }
}

extension DateString on DateTime {
  String get dateString => _dateString();

  String _dateString() {
    return toString().split(' ')[0];
  }
}
