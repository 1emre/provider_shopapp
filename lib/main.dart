import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_shopapp/providers/cart.dart';
import 'package:provider_shopapp/providers/orders.dart';
import 'package:provider_shopapp/providers/products.dart';
import 'package:provider_shopapp/screens/cart_screen.dart';
import 'package:provider_shopapp/screens/edit_product_screen.dart';
import 'package:provider_shopapp/screens/orders_screen.dart';
import 'package:provider_shopapp/screens/product_detail_screen.dart';
import 'package:provider_shopapp/screens/products_overview_screen.dart';
import 'package:provider_shopapp/screens/user_product_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          // intial edilği durumda bu sekılde create ile kullanmak daha efficient
          //if you are creating new instance is recommended.
          create: (ctx) => Products(),
        ),
        ChangeNotifierProvider(create: (ctx) => Cart()),
        ChangeNotifierProvider(
          create: (ctx) => Orders(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MyShop',
        theme: ThemeData(
          //fontFamily: 'Lato',
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.purple)
              .copyWith(secondary: Colors.deepOrange),
        ),
        home: const ProductOverviewScreen(),
        routes: {
          ProductDetailScreen.routeName: (ctx) => const ProductDetailScreen(),
          CartScreen.routName: (ctx) => const CartScreen(),
          OrdersScreen.routeName: (ctx) => const OrdersScreen(),
          UserProductScreen.routeName: (context) => const UserProductScreen(),
          EditProductScreen.routeName: (context) => const EditProductScreen(),
        },
      ),
    );
  }
}
