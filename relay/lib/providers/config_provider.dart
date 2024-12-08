import 'package:flutter/material.dart';
import 'package:relay/models/classes/serializables/config.dart';

class ConfigProvider with ChangeNotifier {
  late Config _config;

  Config get config => _config;

  ConfigProvider(Config config) {
    _config = config;
  }

  set config(Config config) {
    _config = config;
    notifyListeners();
  }

  notifyListenders() {
    notifyListeners();
  }
}
