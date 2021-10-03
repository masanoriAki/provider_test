import 'package:flutter/material.dart';
import 'package:provider_test/main.dart';

class Test extends ChangeNotifier {
  String name = "";

  void addName(val) {
    logger.info("addName $val");
    this.name = val;
    notifyListeners();
  }
}
