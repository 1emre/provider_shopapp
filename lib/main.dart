import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_shopapp/helpers/custom_route.dart';
import 'package:provider_shopapp/providers/auth.dart';
import 'package:provider_shopapp/providers/cart.dart';
import 'package:provider_shopapp/providers/orders.dart';
import 'package:provider_shopapp/providers/products.dart';
import 'package:provider_shopapp/screens/auth_screen.dart';
import 'package:provider_shopapp/screens/cart_screen.dart';
import 'package:provider_shopapp/screens/edit_product_screen.dart';
import 'package:provider_shopapp/screens/orders_screen.dart';
import 'package:provider_shopapp/screens/product_detail_screen.dart';
import 'package:provider_shopapp/screens/products_overview_screen.dart';
import 'package:provider_shopapp/screens/splash_screen.dart';
import 'package:provider_shopapp/screens/user_products_screen.dart';

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
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        // ChangeNotifierProvider(
        //   // intial edilği durumda bu sekılde create ile kullanmak daha efficient
        //   //if you are creating new instance is recommended.
        //   create: (ctx) => Products(),
        // ),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (context) => Products([], authToken: '', userId: ''),
          update: (ctx, auth, previousProducts) => Products(
              previousProducts == null ? [] : previousProducts.items,
              authToken: auth.token ?? '',
              userId: auth.userId),
        ),
        ChangeNotifierProvider(create: (ctx) => Cart()),
        // ChangeNotifierProvider(
        //   create: (ctx) => Orders(),
        // )
        ChangeNotifierProxyProvider<Auth, Orders>(
            create: ((context) => Orders(
                  [],
                  userId: '',
                  authToken: '',
                )),
            update: (ctx, auth, previousOrders) => Orders(
                previousOrders == null ? [] : previousOrders.orders,
                userId: auth.userId,
                authToken: auth.token!))
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'MyShop',
          theme: ThemeData(
            fontFamily: 'Lato',
            pageTransitionsTheme: PageTransitionsTheme(builders: {
              TargetPlatform.android: CustomPageTransitionBuilder(),
              TargetPlatform.iOS: CustomPageTransitionBuilder(),
            }),
            colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.purple)
                .copyWith(secondary: Colors.deepOrange),
          ),
          home: auth.isAuth
              ? const ProductOverviewScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen(),
                ),
          routes: {
            ProductDetailScreen.routeName: (ctx) => const ProductDetailScreen(),
            CartScreen.routName: (ctx) => const CartScreen(),
            OrdersScreen.routeName: (ctx) => const OrdersScreen(),
            UserProductsScreen.routeName: (context) => UserProductsScreen(),
            EditProductScreen.routeName: (context) => const EditProductScreen(),
          },
        ),
      ),
    );
  }
}
