import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_shopapp/providers/products.dart';
import 'package:provider_shopapp/screens/edit_product_screen.dart';
import 'package:provider_shopapp/widgets/app_drawer.dart';

import '../widgets/user_product_item.dart';

class UserProductScreen extends StatelessWidget {
  const UserProductScreen({Key? key}) : super(key: key);

  static const routeName = '/user-products';

  @override
  Widget build(BuildContext context) {
    final productData = context.watch<Products>();
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text('Your Product'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductScreen.routeName);
              },
              icon: const Icon(Icons.add))
        ],
      ),
      drawer: const AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.separated(
            separatorBuilder: (context, index) => const Divider(),
            itemCount: productData.items.length,
            itemBuilder: (_, i) => UserProductItem(
                  id: productData.items[i].id,
                  tittle: productData.items[i].tittle,
                  imageUrl: productData.items[i].imageUrl,
                )),
      ),
    );
  }
}
