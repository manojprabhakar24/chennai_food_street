import 'package:flutter/material.dart';

class MenuProvider with ChangeNotifier {
  // **Menu Items**
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
      'name': 'Biryani',
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
      'description': 'A rich, coffee-flavored dessert made with mascarpone cheese and butter.',
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
      'name': 'Volcano Pizza',
      'price': 1000.0,
      'category': 'Pizza',
      'image': 'assets/images/pizza.jpg',
      'description': 'A spicy pizza with fresh mozzarella, tomato sauce, and fiery toppings.',
    },
  ];

  // **State Management Fields**
  String _searchQuery = '';

  List<Map<String, dynamic>> _filteredMenuItems = [];
  String _selectedCategory = 'All';
  final List<Map<String, dynamic>> _cartItems = [];
  final Map<int, int> _itemCounts = {}; // Tracks item quantities in cart
  final List<int> _favoriteItems = []; // Stores favorite item IDs
// **Unfiltered Menu Items Getter**
  List<Map<String, dynamic>> get menuItems => List.unmodifiable(_menuItems);

  // **Category Management**
  String get selectedCategory => _selectedCategory;

  void selectCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  // **Search Query Management**
  String get searchQuery => _searchQuery;

  void updateSearchQuery(String query) {
    _searchQuery = query;
    if (query.isEmpty) {
      _filteredMenuItems = _menuItems;  // Show all items if search is cleared
    } else {
      _filteredMenuItems = _menuItems
          .where((item) =>
          item['name'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  // **Filtered Menu Items**
  List<Map<String, dynamic>> get filteredMenuItems {
    List<Map<String, dynamic>> items = _menuItems;

    // Filter by selected category
    if (_selectedCategory != 'All') {
      items = items.where((item) => item['category'] == _selectedCategory).toList();
    }

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      items = items
          .where((item) =>
      item['name'].toLowerCase().contains(_searchQuery) ||
          item['description'].toLowerCase().contains(_searchQuery))
          .toList();
    }

    return items;
  }

  // **Cart Management**
  List<Map<String, dynamic>> get cartItems => _cartItems;

  bool isInCart(int id) => _cartItems.any((item) => item['id'] == id);

  void addToCart(Map<String, dynamic> item) {
    if (!_cartItems.any((cartItem) => cartItem['id'] == item['id'])) {
      _cartItems.add(item);
      _itemCounts[item['id']] = 1; // Initialize quantity to 1 when added to cart
      notifyListeners();
    }
  }

  void removeFromCart(int id) {
    _cartItems.removeWhere((item) => item['id'] == id);
    _itemCounts.remove(id); // Remove count when item is removed
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    _itemCounts.clear();
    notifyListeners();
  }

  // **Cart Item Count Management**
  int getItemCount(int itemId) => _itemCounts[itemId] ?? 0;

  void increaseItemCount(int itemId) {
    _itemCounts[itemId] = (_itemCounts[itemId] ?? 0) + 1;
    notifyListeners();
  }

  void decreaseItemCount(int itemId) {
    if (_itemCounts[itemId] != null && _itemCounts[itemId]! > 1) {
      _itemCounts[itemId] = _itemCounts[itemId]! - 1;
      notifyListeners();
    }
  }

  // **Favorite Management**
  List<int> get favoriteItems => _favoriteItems;

  bool isFavorite(int itemId) => _favoriteItems.contains(itemId);

  void addFavorite(int itemId) {
    if (!_favoriteItems.contains(itemId)) {
      _favoriteItems.add(itemId);
      notifyListeners();
    }
  }

  void removeFavorite(int itemId) {
    if (_favoriteItems.contains(itemId)) {
      _favoriteItems.remove(itemId);
      notifyListeners();
    }
  }

  void toggleFavorite(int itemId) {
    if (_favoriteItems.contains(itemId)) {
      _favoriteItems.remove(itemId);
    } else {
      _favoriteItems.add(itemId);
    }
    notifyListeners();
  }
}
