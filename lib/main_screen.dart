import 'package:chennai_food_street/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Discount_screen.dart';
import 'Favourite_screen.dart';
import 'cart_page.dart';
import 'homepage.dart';

class RestaurantHomepage extends StatefulWidget {
  @override
  _RestaurantHomepageState createState() => _RestaurantHomepageState();
}

class _RestaurantHomepageState extends State<RestaurantHomepage> {
  int _currentIndex = 0;

  // Define pages for each tab
  final List<Widget> _pages = [
    HomeScreen(),
    FavoritesScreen(),
    OffersScreen(),
    ProfileScreen(),
  ];

  // Colors for the bottom nav bar
  final Color _activeColor = Colors.deepOrangeAccent;
  final Color _inactiveColor = Colors.grey;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chennai Specials'),
        backgroundColor: Colors.deepOrangeAccent,
        actions: [
          // Cart Icon Button
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              // Navigate to the CartScreen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartScreen()),
              );
            },
          ),
        ],
      ),
      body: AnimatedSwitcher(
        duration: Duration(milliseconds: 300),
        child: _pages[_currentIndex], // Smooth page transition
      ),
      bottomNavigationBar: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 8,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          selectedItemColor: _activeColor,
          unselectedItemColor: _inactiveColor,
          showUnselectedLabels: true,
          selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
          unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w400),
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home, size: 30),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite, size: 30),
              label: 'Favorites',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.local_offer, size: 30),
              label: 'Offers',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person, size: 30),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
