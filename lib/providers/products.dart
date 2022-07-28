import 'package:flutter/cupertino.dart';
import 'package:provider_shopapp/providers/product.dart';

class Products with ChangeNotifier {
  final List<Product> _items = [
    Product(
        id: 'p1',
        tittle: 'Red Shirt',
        description: 'A red shirt - it is pretty red!',
        price: 29.99,
        imageUrl:
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTqEZkYcoDxEMkjJnshct-XjgVeHVI0iVZEfA&usqp=CAU'),
    Product(
        id: 'p2',
        tittle: 'Trousers',
        description: 'A nice pair of trousers',
        price: 59.99,
        imageUrl:
            'https://www.bfgcdn.com/1500_1500_90/011-0065-1811/fjaellraeven-nils-trousers-jeans.jpg'),
    Product(
        id: 'p3',
        tittle: 'Yellow Scarf',
        description: 'Warm and cozy - exactly what you need for the winter.',
        price: 19.99,
        imageUrl:
            'https://thumbs.dreamstime.com/b/yellow-knitted-scarf-18952858.jpg'),
    Product(
        id: 'p4',
        tittle: 'A pan',
        description: 'Prepare any meal you want',
        price: 49.99,
        imageUrl:
            'https://image.shutterstock.com/image-photo/black-fry-pan-over-white-260nw-750875404.jpg'),
  ];

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  void addProduct(Product product) {
    final newProduct = Product(
      id: DateTime.now().toString(),
      tittle: product.tittle,
      description: product.description,
      price: product.price,
      imageUrl: product.imageUrl,
    );
    _items.add(newProduct);
    notifyListeners();
  }

  void updateProduct(String id, Product newProduct) {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      return;
    }
  }

  void deleteProduct(String id) {
    _items.removeWhere((prod) => prod.id == id);
    notifyListeners();
  }
}
