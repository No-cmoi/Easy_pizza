import 'dart:collection';
import 'package:flutter/material.dart';

class LikesProvider extends ChangeNotifier{

  final List<String> _chosenPizza = [];

  UnmodifiableListView<String> get chosenPizza => UnmodifiableListView(_chosenPizza);

  void addPizza(String likedPizzaId) {
    if (!_chosenPizza.contains(likedPizzaId)) {
      _chosenPizza.add(likedPizzaId);
      notifyListeners();
    }
  }

  void removePizza(String pizzaToRemoveId) {
    if (_chosenPizza.contains(pizzaToRemoveId)) {
      _chosenPizza.remove(pizzaToRemoveId);
      notifyListeners();
    }
  }

  bool isPizzaLiked(String pizzaId) {
    return _chosenPizza.contains(pizzaId);
  }
}