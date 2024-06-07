
import 'package:customizable_counter/customizable_counter.dart';
import 'package:easy_pizza/models/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';


class PizzaCart extends StatelessWidget {
  const PizzaCart({super.key});

   @override
  Widget build(BuildContext context) {
   return Scaffold(
    appBar: AppBar(
        title: const Text('cart'),
         leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/');
          },
        ),
        ),
      
        body: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cartProvider.pizzaCart.length,
                  itemBuilder: (context, index) {
                    final pizza = cartProvider.pizzaCart[index];
                    return ListTile(
                      title: Text(pizza.name),
                      leading: Text('${pizza.price.toStringAsFixed(2)}€'),
                      subtitle: Text('Ingredients: ${pizza.ingredients.join(', ')}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomizableCounter(
                            borderColor: Colors.red,
                            borderWidth: 5,
                            borderRadius: 100,
                            backgroundColor: Colors.red[900],
                            buttonText: "Add More",
                            textColor: Colors.white,
                            textSize: 22,
                            count: 1,
                            step: 1,
                            minCount: 0,
                            maxCount: 10,
                            incrementIcon: const Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                            decrementIcon: const Icon(
                              Icons.remove,
                              color: Colors.white,
                            ),
                            onCountChange: (count) {

                            },
                            onIncrement: (count) {
                              cartProvider.addPizza(pizza);
                            },
                            onDecrement: (count) {
                              cartProvider.removePizza(pizza);
                            },
                          )
                       ],
                      ),
                    );
                  },
                ),
              ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                  'Total: ${cartProvider.totalCart.toStringAsFixed(2)}€',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
                IconButton(
                icon: const Icon(Icons.remove_shopping_cart_rounded),
                onPressed: (){
                  cartProvider.clearPizza();
              
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
