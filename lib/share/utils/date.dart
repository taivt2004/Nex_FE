import 'package:intl/intl.dart';

bool validateBirthday(String birthday) {
  // Check if the entered date is in the correct format (dd/MM/yyyy)
  try {
    final enteredDate = DateFormat('dd/MM/yyyy').parseStrict(birthday);

    // Check if the date is in the future
    final today = DateTime.now();
    if (enteredDate.isAfter(today)) {
      return false;
    }

    // Check if the user is at least 16 years old
    final minDate = today.subtract(const Duration(days: 16 * 365));
    if (enteredDate.isAfter(minDate)) {
      return false;
    }
  } catch (e) {
    return false;
  }
  return true;
}
