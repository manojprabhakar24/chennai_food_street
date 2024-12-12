import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cart_page.dart'; // Import your cart page
import '../provider/menu.dart'; // Make sure MenuProvider is imported
import 'profile_screen.dart';
import 'Discount_screen.dart';
import 'Favourite_screen.dart';
import 'homepage.dart';
import 'package:badges/badges.dart' as badges;  // Alias the badges package

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
        title: Center(
          child: Text(
            'Chennai Food Street',
            style: TextStyle(
              fontSize: 24, // Font size
              fontWeight: FontWeight.bold, // Font weight
              fontFamily: 'Roboto', // Customize the font family (use a valid font)
              color: Colors.white, // Font color
            ),
          ),
        ),        backgroundColor: Colors.deepOrangeAccent,
        actions: [
          Consumer<MenuProvider>(
            builder: (context, menuProvider, child) {
              return Padding(
                  padding: EdgeInsets.only(right: 20), // Add some padding to move it left
              child: badges.Badge(
                badgeContent: Text(
                  menuProvider.cartItems.length.toString(),
                  style: TextStyle(color: Colors.white),
                ),

                child: IconButton(
                  icon: Icon(Icons.shopping_cart),
                  onPressed: () {
                    // Directly navigate to the CartScreen
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CartScreen()),
                    );
                  },
                )
              ));
            },
          )

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
