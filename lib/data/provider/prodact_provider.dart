import 'package:flutter/material.dart';
import 'package:pagebeya/data/models/product.dart';
import 'package:pagebeya/data/services/prodact_services.dart';

class ProductProvider with ChangeNotifier {
  final ProductService service;
  List<Product> _products = [];
  bool _isLoading = false;
  String? _error;

  ProductProvider(this.service);

  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadProducts() async {
    _isLoading = true;
    notifyListeners();
    try {
      _products = await service.fetchProducts();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
