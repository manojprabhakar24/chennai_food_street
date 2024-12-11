import 'package:flutter/material.dart';

class MenuProvider with ChangeNotifier {
  // Menu and cart items
  List<Map<String, dynamic>> _cartItems = [];
  final List<Map<String, dynamic>> _menuItems = [
    {
      'id': 1,
      'name': 'Margherita Pizza',
      'price': 799.20,
      'category': 'Pizza',
      'image': 'assets/images/pizza.jpg',
      'description': 'A classic pizza with fresh mozzarella, tomato sauce, and basil.',
    },
    {
      'id': 2,
      'name': 'Briyani',
      'price': 639.20,
      'category': 'Rice',
      'image': 'assets/images/briyani.jpg',
      'description': 'A fragrant rice dish with spices and tender meat, served with raita.',
    },
    {
      'id': 3,
      'name': 'Tiramisu',
      'price': 479.20,
      'category': 'Desserts',
      'image': 'assets/images/cake.jpg',
      'description': 'A rich, coffee-flavored dessert made with mascarpone cheese.',
    },
    {
      'id': 4,
      'name': 'Espresso',
      'price': 239.20,
      'category': 'Drinks',
      'image': 'assets/images/coffee.jpg',
      'description': 'A strong, concentrated coffee made by forcing steam through finely ground coffee.',
    },
    {
      'id': 5,
      'name': 'Spaghetti Carbonara',
      'price': 1039.20,
      'category': 'Pasta',
      'image': 'assets/images/pasta.jpg',
      'description': 'A creamy pasta dish made with eggs, cheese, pancetta, and pepper.',
    },
    {
      'id': 6,
      'name': 'volcano Pizza',
      'price': 1000,
      'category': 'Pizza',
      'image': 'assets/images/pizza.jpg',
      'description': 'A classic pizza with fresh mozzarella, tomato sauce, and basil.',
    },
  ];

  final Map<int, int> _itemCounts = {};
  final List<int> _favoriteItems = []; // List to hold favorite item IDs
  String _selectedCategory = 'All';

  // Getters
  String get selectedCategory => _selectedCategory;
  List<Map<String, dynamic>> get menuItems => _menuItems;

  List<Map<String, dynamic>> get filteredMenuItems {
    if (_selectedCategory == 'All') {
      return _menuItems;
    }
    return _menuItems.where((item) => item['category'] == _selectedCategory).toList();
  }

  List<Map<String, dynamic>> get cartItems => _cartItems;
  List<int> get favoriteItems => _favoriteItems;

  // Category Selection
  void selectCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  // Cart Functions
  bool isInCart(int id) => _cartItems.any((item) => item['id'] == id);

  void addToCart(Map<String, dynamic> item) {
    if (!_cartItems.any((cartItem) => cartItem['id'] == item['id'])) {
      _cartItems.add(item);
      _itemCounts[item['id']] = 1; // Initialize quantity to 1 when added to the cart
      notifyListeners();
    }
  }


  void removeFromCart(int id) {
    _cartItems.removeWhere((item) => item['id'] == id);
    notifyListeners();
  }
  void clearCart() {
    _cartItems.clear();
    _itemCounts.clear();
    notifyListeners(); // Notify listeners that the cart has been cleared
  }
  // Item Count Functions
  void increaseItemCount(int itemId) {
    _itemCounts[itemId] = (_itemCounts[itemId] ?? 0) + 1;
    notifyListeners();
  }

  void decreaseItemCount(int itemId) {
    if (_itemCounts[itemId] != null && _itemCounts[itemId]! > 0) {
      _itemCounts[itemId] = _itemCounts[itemId]! - 1;
      notifyListeners();
    }
  }

  int getItemCount(int itemId) {
    return _itemCounts[itemId] ?? 0;
  }

  // Favorite Functions
  bool isFavorite(int itemId) => _favoriteItems.contains(itemId);

  void addFavorite(int itemId) {
    if (!_favoriteItems.contains(itemId)) {
      _favoriteItems.add(itemId);
      notifyListeners();
    }
  }
  void toggleFavorite(int itemId) {
    if (_favoriteItems.contains(itemId)) {
      // If the item is already in favorites, remove it
      _favoriteItems.remove(itemId);
    } else {
      // Otherwise, add the item to favorites
      _favoriteItems.add(itemId);
    }
    notifyListeners(); // Notify listeners to update the UI
  }
  void removeFavorite(int itemId) {
    _favoriteItems.remove(itemId);
    notifyListeners();
  }
}
