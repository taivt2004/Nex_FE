import 'package:flutter/material.dart';

class NotchBottomBarController extends ChangeNotifier {
  NotchBottomBarController({this.index = 0});
  int index;
  int? oldIndex;
  
  void jumpTo(int index) {
    oldIndex = this.index;
    this.index = index;
    notifyListeners();
  }
}
