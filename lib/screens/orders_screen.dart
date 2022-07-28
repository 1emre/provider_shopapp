import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_shopapp/providers/orders.dart' show Orders;
import 'package:provider_shopapp/widgets/app_drawer.dart';

import '../widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({Key? key}) : super(key: key);
  static const routeName = '/order';
  @override
  Widget build(BuildContext context) {
    final orderData = context.watch<Orders>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Orders'),
      ),
      drawer: const AppDrawer(),
      body: ListView.builder(
          itemCount: orderData.orders.length,
          itemBuilder: (ctx, i) => OrderItem(
                order: orderData.orders[i],
              )),
    );
  }
}
