// ignore_for_file: prefer_final_locals

import 'package:basic_utils/basic_utils.dart';

String toStrings(List<String> map) {
  var result = <String>[];
  for (final value in map) {
    result.add(value.trim());
  }
  return result.join(',');
}

bool isNotNullOrEmpty(String? s) {
  if (StringUtils.isNotNullOrEmpty(s)) {
    return false;
  }
  if (s != null && ('null'.compareTo(s) == 0 || 'NULL'.compareTo(s) == 0)) {
    return false;
  }
  return StringUtils.isNotNullOrEmpty(s);
}
