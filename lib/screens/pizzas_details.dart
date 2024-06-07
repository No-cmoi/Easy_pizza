import 'package:easy_pizza/models/likes_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../models/pizza.dart';

class PizzasDetails extends StatelessWidget {
  final Pizza pizza; 

  const PizzasDetails({super.key, required this.pizza});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pizza.name),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/');
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Image(image: AssetImage("images/pizza.png")),
            Text('Name: ${pizza.name}'),
            Text('Price:${pizza.price.toStringAsFixed(2)} €'),
            Text('Ingredients: ${pizza.ingredients.join(', ')}'),
            Text('Category: ${pizza.category.name}'),
            Consumer<LikesProvider>(
              builder: (context, likesProvider, child) {
                bool isFavorite = likesProvider.isPizzaLiked(pizza.id);
                return IconButton(
                  iconSize: 30,
                  icon: const Icon(Icons.favorite),
                  color: isFavorite ? Colors.red : const Color.fromARGB(62, 78, 78, 78),
                  onPressed: () {
                    if (isFavorite) {
                      likesProvider.removePizza(pizza.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Removed from favorites')),
                      );
                    } else {
                      likesProvider.addPizza(pizza.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Added to favorites')),
                      );
                    }
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
