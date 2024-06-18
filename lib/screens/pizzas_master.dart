import 'dart:convert';
import 'package:easy_pizza/models/discount.dart';
import 'package:flutter/foundation.dart';
import 'package:easy_pizza/models/cart_provider.dart';
import 'package:easy_pizza/models/likes_provider.dart';
import 'package:flutter/material.dart';
import 'package:easy_pizza/data/db.dart' as db;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class PizzasMaster extends StatefulWidget {
  const PizzasMaster({super.key});

  @override
  PizzasMasterState createState() => PizzasMasterState();
}

class PizzasMasterState extends State<PizzasMaster> {


  @override
  Widget build(BuildContext context) {

     Future<void> subscribeToDiscounts() async {
      await dotenv.load(fileName: "easy_pizza.env");

      final Uri wsUrl = Uri.parse(dotenv.env["WEBSOCKET_API"]!);
      final channel = WebSocketChannel.connect(wsUrl);

      await channel.ready;

      //abonnement au serveur websocket
      channel.sink.add(
        jsonEncode(
          {"collection": "discounts", "type": "subscribe"},
        ),
      );

      channel.stream.listen((data) {
        final Map<String, dynamic> response = jsonDecode(data);

        if (response["type"] == "subscription") {
          final Discount lastDiscount = Discount.fromJson(response["data"][0]);

          final snackBar = SnackBar(
            content: Text(lastDiscount.code),
          );

          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
        for (var element in response["data"]) {
          // ignore: avoid_print
          print(element);
        }
      }, onError: (error) {
        if (kDebugMode) {
          print(error);
          
        }
      });
    }

    subscribeToDiscounts();
      
    return Scaffold(
      appBar: AppBar(
        title: const SizedBox(
          width: 60,
          child:Image(image: AssetImage("images/easypizzas-logo.png")),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green, Colors.white, Colors.red],
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
            onPressed: () {
              context.go('/cart');
            },
          ),
        ],
      ),
      body: Center(
        child: 
             Consumer<LikesProvider>(
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
            )
          )
      );
    }
  }
