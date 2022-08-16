// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import 'package:provider_shopapp/models/http_exception.dart';
import 'package:provider_shopapp/providers/product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //     id: 'p1',
    //     tittle: 'Red Shirt',
    //     description: 'A red shirt - it is pretty red!',
    //     price: 29.99,
    //     imageUrl:
    //         'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTqEZkYcoDxEMkjJnshct-XjgVeHVI0iVZEfA&usqp=CAU'),
    // Product(
    //     id: 'p2',
    //     tittle: 'Trousers',
    //     description: 'A nice pair of trousers',
    //     price: 59.99,
    //     imageUrl:
    //         'https://www.bfgcdn.com/1500_1500_90/011-0065-1811/fjaellraeven-nils-trousers-jeans.jpg'),
    // Product(
    //     id: 'p3',
    //     tittle: 'Yellow Scarf',
    //     description: 'Warm and cozy - exactly what you need for the winter.',
    //     price: 19.99,
    //     imageUrl:
    //         'https://thumbs.dreamstime.com/b/yellow-knitted-scarf-18952858.jpg'),
    // Product(
    //     id: 'p4',
    //     tittle: 'A pan',
    //     description: 'Prepare any meal you want',
    //     price: 49.99,
    //     imageUrl:
    //         'https://image.shutterstock.com/image-photo/black-fry-pan-over-white-260nw-750875404.jpg'),
  ];

  final String authToken;
  final String userId;
  Products(
    _items, {
    required this.authToken,
    required this.userId,
  });

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    final filterString =
        filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    var url = Uri.parse(
        'https://shopapp-48249-default-rtdb.firebaseio.com/products.json?auth=$authToken&$filterString');

    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      //print(extractedData);
      if (extractedData == null) {
        return;
      }
      url = Uri.parse(
          'https://shopapp-48249-default-rtdb.firebaseio.com/userFavorites/$userId.json?auth=$authToken');
      final favoriteResponse = await http.get(url);
      final favoriteData =
          json.decode(favoriteResponse.body) as Map<String, dynamic>?;
      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        // print(favoriteData![prodId] == null
        //     ? false
        //     : favoriteData[prodId][prodId]);

        loadedProducts.add(Product(
          id: prodId,
          tittle: prodData['tittle'],
          description: prodData['description'],
          price: prodData['price'],
          imageUrl: prodData['imageUrl'],
          //isFavorite: false,
          isFavorite: favoriteData == null
              ? false
              : (favoriteData[prodId] == null
                  ? false
                  : favoriteData[prodId][prodId] ?? false),
        ));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> addProduct(Product product) async {
    final url = Uri.parse(
        'https://shopapp-48249-default-rtdb.firebaseio.com/products.json?auth=$authToken');

    try {
      final response = await http.post(url,
          body: json.encode({
            'tittle': product.tittle,
            'description': product.description,
            'price': product.price,
            'imageUrl': product.imageUrl,
            'creatorId': userId,
          }));

      final newProduct = Product(
          id: json.decode(response.body)['name'],
          tittle: product.tittle,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl,
          isFavorite: product.isFavorite);
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url = Uri.parse(
          'https://shopapp-48249-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken');
      await http.patch(url,
          body: json.encode({
            'tittle': newProduct.tittle,
            'description': newProduct.description,
            'price': newProduct.price,
            'imageUrl': newProduct.imageUrl,
          }));
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      return;
    }
  }

  Future<void> deleteProduct(String id) async {
    final url = Uri.parse(
        'https://shopapp-48249-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken');
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product');
    }
    existingProduct = null!;
  }
}
