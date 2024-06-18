
import 'package:easy_pizza/data/db.dart' as db;
import 'package:easy_pizza/models/cart_provider.dart';
import 'package:easy_pizza/models/likes_provider.dart';
import 'package:easy_pizza/models/pizza.dart';
import 'package:easy_pizza/models/user_provider.dart';

import 'package:easy_pizza/screens/pizza_cart.dart';
import 'package:easy_pizza/screens/pizzas_favorites.dart';
import 'package:easy_pizza/screens/pizzas_details.dart';
import 'package:easy_pizza/screens/pizzas_master.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async{
  await dotenv.load(fileName: "easy_pizza.env");
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) =>LikesProvider()),
        ChangeNotifierProvider(create: (context) => CartProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
      ],
      child: MainApp(),
    ));
}

  class MainApp extends StatelessWidget {
   MainApp({super.key});

final _router =GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const PizzasMaster(),
      ),
    GoRoute(
            path: '/details/:id',
            builder: (context, state) {
              final pizzaId = state.pathParameters['id'];
              final pizzaToFind = db.pizzas.where((i) => i.id == (pizzaId!));
              final Pizza p = pizzaToFind.first;
              return PizzasDetails(pizza: p,);
            }
          ),
          GoRoute(
            path: '/favorites',
            builder: (context, state) => const PizzaFavorites(),
          ),
          GoRoute(
            path: '/cart',
            builder: (context, state) => const PizzaCart(promotions: [],),
          ),
      ],
  );
        

   @override
  Widget build(BuildContext context) {
      return MaterialApp.router(
         routerConfig: _router,
    );
  }
}
