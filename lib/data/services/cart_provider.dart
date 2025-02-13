import 'package:flutter/material.dart';

import 'package:pagebeya/data/models/cartitem.dart';

import 'package:pagebeya/data/services/cart_services.dart';

class CartProvider with ChangeNotifier {
  final CartService service;
  List<CartItem> _items = [];
  bool _isLoading = false;
  String? _error;

  CartProvider(this.service);

  List<CartItem> get items => _items;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadCart(String userId) async {
    _isLoading = true;
    notifyListeners();
    try {
      _items = await service.fetchCart(userId);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addItem(String userId, String productId, int quantity) async {
    _isLoading = true;
    notifyListeners();
    try {
      final item = await service.addToCart(userId, productId, quantity);
      _items.add(item);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> removeItem(String cartId) async {
    _items.removeWhere((item) => item.id == cartId);
    notifyListeners();
  }
}
