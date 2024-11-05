import 'package:flutter/foundation.dart';

class CounterProvider with ChangeNotifier {
  int _count = 0;

  int get count => _count;

  void incrementCount() {
    _count++;
    notifyListeners();
  }

  void decrementCount() {
    _count--;
    notifyListeners();
  }

  void resetCount() {
    _count = 0;
    notifyListeners();
  }
}
