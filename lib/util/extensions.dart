import 'package:intl/intl.dart';

extension StandardDate on DateTime {
  String toStandardDate() {
    return DateFormat('MMM dd, yyyy').format(this);
  }

  String toStandardBritishDate() {
    return DateFormat('dd MMM yyyy').format(this);
  }
}
