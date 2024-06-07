import 'package:uuid/uuid.dart';

var uuid = const Uuid();


class Pizza {

String id;
String name;
double price;
List<String> ingredients;
Category category;

Pizza( {
  required this.name, 
  required this.price,
  required this.ingredients, 
  required this.category
  }) 
  : id = uuid.v4();

}

enum Category {
  rossa,
  bianca,
  veggie
}