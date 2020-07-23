import 'package:intl/intl.dart';

const String FORMAT_APOD = "yyyy-MM-dd";

final DateFormat dateFormatApod = DateFormat(FORMAT_APOD);

extension DateToString on DateTime {
  String formatDateApod() {
    return dateFormatApod.format(this);
  }
}

extension StringToDate on String {
  DateTime formatDateApod() {
    return dateFormatApod.parse(this);
  }
}
