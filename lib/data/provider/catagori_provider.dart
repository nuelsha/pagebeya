import 'package:flutter/material.dart';
import 'package:pagebeya/data/models/Category.dart';

import 'package:pagebeya/data/services/categoryService.dart';

class CategoryProvider with ChangeNotifier {
  final CategoryService _service;
  List<Category> _categories = [];
  Category? _selectedCategory;
  bool _isLoading = false;
  String? _error;

  CategoryProvider(this._service);

  // Getters
  List<Category> get categories => _categories;
  Category? get selectedCategory => _selectedCategory;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Main loading method
  Future<void> loadCategories() async {
    _isLoading = true;
    notifyListeners();

    try {
      _categories = await _service.fetchCategories();
      _error = null;
    } catch (e) {
      _error = e.toString();
      _categories = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Select category for filtering
  void selectCategory(Category category) {
    _selectedCategory = category;
    notifyListeners();
  }

  // Clear category selection
  void clearSelection() {
    _selectedCategory = null;
    notifyListeners();
  }

  // Error reset
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
