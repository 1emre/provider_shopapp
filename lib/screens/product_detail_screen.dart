import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_shopapp/providers/products.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({Key? key}) : super(key: key);

  static const routeName = '/product-detail';

  @override
  Widget build(BuildContext context) {
    final productID = ModalRoute.of(context)!.settings.arguments as String;

    final loadedProduct = context.read<Products>().findById(productID);

    return Scaffold(
      // appBar: AppBar(
      //   centerTitle: false,
      //   title: Text(loadedProduct.tittle),
      // ),
      body: //SingleChildScrollView(
          CustomScrollView(
        slivers: [
          SliverAppBar(
            iconTheme: const IconThemeData(
              color: Colors.black,
            ),
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Container(
                width: double.infinity,
                color: Colors.black45,
                child: Text(loadedProduct.tittle,
                    style: const TextStyle(color: Colors.white),
                    textAlign: TextAlign.center),
              ),
              background: FittedBox(
                fit: BoxFit.cover,
                child: Hero(
                  tag: loadedProduct.id,
                  child: Image.network(loadedProduct.imageUrl),
                ),
              ),
            ),
          ),
          SliverList(
              delegate: SliverChildListDelegate([
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            Text(
              '\$${loadedProduct.price}',
              style: const TextStyle(color: Colors.grey, fontSize: 20),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                loadedProduct.description,
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            ),
          ])),
        ],
        // child: Column(
        //   children: [
        //     SizedBox(
        //       width: double.infinity,
        //       child: FittedBox(
        //         child: Hero(
        //           tag: loadedProduct.id,
        //           child: Image.network(loadedProduct.imageUrl),
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
      ),
    );
  }
}
