import 'package:customizable_counter/customizable_counter.dart';
import 'package:easy_pizza/models/cart_provider.dart';
import 'package:easy_pizza/models/discount.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class PizzaCart extends StatefulWidget {
  final List<Discount> promotions;

  const PizzaCart({super.key, required this.promotions});

  @override
  PizzaCartState createState() => PizzaCartState();
}

class PizzaCartState extends State<PizzaCart> {
  final TextEditingController _discountController = TextEditingController();
  String _discountError = '';

  void _applyDiscount(BuildContext context) {
    String discountCode = _discountController.text.trim();

    final discount = widget.promotions.firstWhere(
      (promotion) => promotion.code == discountCode,
      orElse: () => Discount(
        code: '',
        rule: '',
        start: DateTime.now(),
        end: DateTime.now(),
        id: '',
      ),
    );

    if (discount.code.isNotEmpty) {
      Provider.of<CartProvider>(context, listen: false).applyDiscount(double.parse(discount.rule));
      _discountController.clear();
      setState(() {
        _discountError = '';
      });
    } else {
      setState(() {
        _discountError = 'Invalid discount code';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/');
          },
        ),
      ),
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          final totalCart = cartProvider.totalCart.toStringAsFixed(2);

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
                            onCountChange: (count) {},
                            onIncrement: (count) {
                              cartProvider.addPizza(pizza);
                            },
                            onDecrement: (count) {
                              cartProvider.removePizza(pizza);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Total: $totalCart€',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _discountController,
                  decoration:  InputDecoration(
                    labelText: 'Enter discount code',
                    errorText: _discountError,
                    border: const OutlineInputBorder(),
                  ),
                  onSubmitted: (value) {
                    if (value.length == 10 && RegExp(r'^[A-Z0-9]+$').hasMatch(value)) {
                      _applyDiscount(context);
                    } else {
                      setState(() {
                        _discountError = 'Invalid discount code format';
                      });
                    }
                  },
                ),
              ),
              IconButton(
                icon: const Icon(Icons.remove_shopping_cart_rounded),
                onPressed: () {
                  cartProvider.clearPizza();
                },
              ),
              TextButton(
                onPressed: () => _showPromotionsDialog(context),
                child: const Text('Show Promotions'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showPromotionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Promotions'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: widget.promotions.map((promotion) {
              return ListTile(
                title: Text(promotion.code),
                subtitle: Text(promotion.rule),
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
