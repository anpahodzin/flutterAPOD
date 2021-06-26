import 'package:intl/intl.dart';

const String FORMAT_APOD = "yyyy-MM-dd";
const String FORMAT_DATE = "dd MMMM yyyy";

final DateFormat dateFormatApod = DateFormat(FORMAT_APOD);
final DateFormat dateFormatDate = DateFormat(FORMAT_DATE);

extension DateToString on DateTime {
  String formatDateApod() {
    return dateFormatApod.format(this);
  }

  String formatDate() {
    return dateFormatDate.format(this);
  }
}

extension StringToDate on String {
  DateTime formatDateApod() {
    return dateFormatApod.parse(this);
  }
}
