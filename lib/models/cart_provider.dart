import 'dart:collection';
import 'package:easy_pizza/models/pizza.dart';
import 'package:flutter/material.dart';

class CartProvider extends ChangeNotifier {
  final List<Pizza> _pizzaCart = [];
  final Map<Pizza, int> _pizzaQuantities = {};

  UnmodifiableListView<Pizza> get pizzaCart => UnmodifiableListView(_pizzaCart);

  double totalCart = 0;

  void addPizza(Pizza pizza) {
    if (!_pizzaCart.contains(pizza)) {
      _pizzaCart.add(pizza);
      _pizzaQuantities[pizza] = 1;
    } else {
      _pizzaQuantities[pizza] = _pizzaQuantities[pizza]! + 1;
    }
    totalCart += pizza.price;
    notifyListeners();
  }
  
  void removePizza(Pizza pizza) {
    if (_pizzaCart.contains(pizza)) {
      if (_pizzaQuantities[pizza]! > 1) {
        _pizzaQuantities[pizza] = _pizzaQuantities[pizza]! - 1;
        totalCart -= pizza.price;
      } else {
        _pizzaCart.remove(pizza);
        totalCart -= pizza.price;
        _pizzaQuantities.remove(pizza);
      }
      notifyListeners();
    }
  }

  void clearPizza() {
    _pizzaCart.clear();
    _pizzaQuantities.clear();
    totalCart = 0;
    notifyListeners();
  }

  int getQuantity(Pizza pizza) {
    return _pizzaQuantities[pizza] ?? 0;
  }

  void applyDiscount(double discountPercentage) {
    if (discountPercentage > 0 && discountPercentage <= 100) {
      double discountAmount = (discountPercentage / 100) * totalCart;
      totalCart -= discountAmount;
      notifyListeners();
    }
  }
}
