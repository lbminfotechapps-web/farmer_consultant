import 'package:flutter/foundation.dart';

class TabRefresh extends ChangeNotifier {
  static final home = TabRefresh();
  static final followup = TabRefresh();
  static final products = TabRefresh();

  void refresh() => notifyListeners();
}