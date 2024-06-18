import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../models/likes_provider.dart';
import 'package:easy_pizza/data/db.dart' as db;



class PizzaFavorites extends StatelessWidget {
  const PizzaFavorites({super.key});

  @override
  Widget build(BuildContext context) {
   return Scaffold(
    appBar: AppBar(
        backgroundColor: Colors.redAccent[400],
        title: const Text('favorites'),
        foregroundColor:Colors.white,
         leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/');
          },
        ),
      ),
        body: Center(
      child: Consumer<LikesProvider>(
        builder: (context, likesProvider, child) {
          return ListView.builder(
            itemCount: likesProvider.chosenPizza.length,
            itemBuilder: (context, index) {
              final pizzaId = likesProvider.chosenPizza[index];
              final pizza = db.pizzas.firstWhere((p) => p.id == pizzaId);
              return ListTile(
                title: Text(pizza.name),
                subtitle: Text('${pizza.ingredients.length.toString()} ingredients'),
                      leading: const Image(image: AssetImage("images/pizza.png")),
              );
            },
          );
        },
      ),
    ),
   );
  }
}