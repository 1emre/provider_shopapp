import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_shopapp/providers/products.dart';
import 'package:provider_shopapp/widgets/product_item.dart';

import '../core/padding.dart';

class ProductsGrid extends StatelessWidget {
  final bool showFavs;
  const ProductsGrid({Key? key, required this.showFavs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productsData = context.read<Products>();
    final products = showFavs ? productsData.favoriteItems : productsData.items;
    return GridView.builder(
        padding: const PagePadding.low(),
        itemCount: products.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, //amount of columns i want to have
            childAspectRatio: 3 / 2, //a bit taller than there are wide
            crossAxisSpacing: 10, //the space between the columns
            mainAxisSpacing: 10 //the space between the rows
            ),
        itemBuilder: (ctx, i) {
          return //ChangeNotifierProvider( ChangeNotifierProvider.value nested provider patterde dataya baglı islem yaptıgımız ıcın sadece value ile datadekı degıısklıgı dinliyoruz.
              // ChangeNotifierProvider ile widgettaki değişikliği bize geri döndürüyor.
              ChangeNotifierProvider.value(
            // product class objelerine ulasabilmek icin burda nestest bir provider yapısı kullandık her product ıcın bir provider yaratılmıs oldu.
            value: products[i],
            //create: (c) => products[i],
            child: const ProductItem(),
          );
        });
  }
}
