import 'package:easy_pizza/models/pizza.dart';



final List<Pizza> pizzas = [
  Pizza(name: "Margherita", price: 6, ingredients: ["tomate", "mozarella"], category:Category.rossa),
  Pizza(name: "Quattro Stagioni", price: 12,ingredients: ["tomate", "mozarella", "origan"],category:Category.rossa),
  Pizza(name: "Capricciosa", price: 11,ingredients: ["tomate", "mozarella", "capre"],category:Category.rossa),
  Pizza(name: "Marinara", price: 5,ingredients: ["tomate", "mozarella", "basilic"],category:Category.rossa),
  Pizza(name: "Regina", price: 10,ingredients: ["tomate", "mozarella", "olives"],category:Category.rossa),
  Pizza(name: "Diavola", price: 10,ingredients: ["tomate", "mozarella", "chorizzo", "parmesan"],category:Category.rossa),
  Pizza(name: "Quattro Formaggi", price: 12,ingredients: ["tomate", "mozarella", "chevre", "bleu", "emmental"],category:Category.rossa),
  Pizza(name: "Parma", price: 13,ingredients: ["tomate", "mozarella", "jambon de parme"],category:Category.rossa),
  Pizza(name: "Bianca", price: 10,ingredients: [" mozarella", "oignons", "piment", "romarin"],category:Category.bianca),
  Pizza(name: "Ortolana", price: 6, ingredients: ["tomate", "mozarella", "courgettes", "aubergines"],category:Category.veggie),
];
