// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/cupertino.dart';

class CartItem {
  final String id;
  final String tittle;
  final int quantity;
  final double price;
  CartItem({
    required this.id,
    required this.tittle,
    required this.quantity,
    required this.price,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    int sumCartItemQuantity = _items.values
        .map((e) => e.quantity)
        .toList()
        .fold(0, (previousValue, element) => previousValue + element);
    return sumCartItemQuantity;
  }

  double get totalAmount {
    double total = 0;
    _items.forEach((key, value) {
      total += value.price * value.quantity;
    });

    return total;
  }

  void addItem(String productId, String tittle, double price) {
    if (_items.containsKey(productId)) {
      //change quantity
      //update function automatically gets the existing cart item,
      _items.update(
        productId,
        (existingCartItem) => CartItem(
          id: existingCartItem.id,
          tittle: existingCartItem.tittle,
          quantity: existingCartItem.quantity + 1,
          price: existingCartItem.price,
        ),
      );
    } else {
      //yeni item eklemek icin
      _items.putIfAbsent(
        productId,
        () => CartItem(
          id: DateTime.now().toString(),
          tittle: tittle,
          quantity: 1,
          price: price,
        ),
      );
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }

    if (_items[productId]!.quantity > 1) {
      _items.update(
        productId,
        (existingCartItem) => CartItem(
            id: existingCartItem.id,
            tittle: existingCartItem.tittle,
            quantity: existingCartItem.quantity - 1,
            price: existingCartItem.price),
      );
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
