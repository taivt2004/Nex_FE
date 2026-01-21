import 'package:nexpaylab/app/app.dart';
import 'package:nexpaylab/bootstrap.dart';
import 'package:nexpaylab/shared/constants/app_constants.dart';

void main() {
  bootstrap(() => const App(), Environment.staging);
}
