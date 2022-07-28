import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_shopapp/core/padding.dart';
import 'package:provider_shopapp/providers/cart.dart' show Cart;
import 'package:provider_shopapp/widgets/cart_item.dart';

import '../providers/orders.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  static const routName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<Cart>();
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text('Your Cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: const PagePadding.margin(),
            child: Padding(
              padding: const PagePadding.low(),
              child: Row(
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  const Spacer(),
                  Chip(
                    label: Text(
                      '\$${cart.totalAmount}',
                      style: TextStyle(
                          color: Theme.of(context)
                              .primaryTextTheme
                              .headline6!
                              .color),
                    ),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  TextButton(
                    onPressed: () {
                      context.read<Orders>().addOrder(
                          cart.items.values.toList(), cart.totalAmount);
                      cart.clear();
                    },
                    child: const Text('Order Now'),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),
          Expanded(
              child: ListView.builder(
            itemCount: cart.items.length,
            itemBuilder: (ctx, i) => CartItem(
                id: cart.items.values.toList()[i].id,
                productId: cart.items.keys.toList()[i],
                price: cart.items.values.toList()[i].price,
                tittle: cart.items.values.toList()[i].tittle,
                quantity: cart.items.values.toList()[i].quantity),
          ))
        ],
      ),
    );
  }
}
