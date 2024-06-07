import 'package:easy_pizza/models/cart_provider.dart';
import 'package:easy_pizza/models/likes_provider.dart';
import 'package:flutter/material.dart';
import 'package:easy_pizza/data/db.dart' as db;
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class PizzasMaster extends StatelessWidget {
  const PizzasMaster({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Our Pizzas'),
        flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green, Colors.white, Colors.orange],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
         leading: IconButton(
          icon: const Icon(Icons.favorite),
          onPressed: () {
            context.go('/favorites');
          },
        ),
        actions: [
          IconButton(
          icon: const Icon(Icons.shopping_cart),
          onPressed: (){
            context.go('/cart');
          },
          ),
        ],
      ),
        body: Center(
        child: Consumer<LikesProvider>(
          builder: (context, likesProvider, child) {
            return ListView.builder(
              itemCount: db.pizzas.length,
              itemBuilder: (context, index) {
                final pizza = db.pizzas[index];
                bool isFavorite = likesProvider.isPizzaLiked(pizza.id);
                return ListTile(
                  title: Text(pizza.name),
                  subtitle: Text('${pizza.ingredients.length.toString()} ingredients'),
                  leading: const Image(image: AssetImage("images/pizza.png")),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("${pizza.price.toStringAsFixed(2)}€"),
                      const SizedBox(width: 10),
                      Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : null,
                      ),
                      const SizedBox(width: 10),
                      IconButton(
                        icon: const Icon(Icons.add_shopping_cart_rounded),
                        onPressed: () {
                          Provider.of<CartProvider>(context, listen: false).addPizza(pizza);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('${pizza.name} added to cart')),
                          );
                        },
                      ),
                    ],
                  ),
                  onTap: () {
                    context.go('/details/${pizza.id}');
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
  }