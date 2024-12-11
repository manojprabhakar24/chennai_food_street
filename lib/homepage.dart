import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'menu.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(  // Allows scrolling for the entire body
        child: Column(
          children: [
            _buildSearchBar(),
            _buildCategories(context),
            _buildFoodGrid(context),
          ],
        ),
      ),
    );
  }

  // Search Bar Widget
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search for food...',
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  // Categories Widget
  Widget _buildCategories(BuildContext context) {
    final categories = ['All', 'Pizza', 'Pasta', 'Rice', 'Desserts', 'Drinks'];
    final menuProvider = Provider.of<MenuProvider>(context);

    return Container(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ChoiceChip(
              label: Text(categories[index]),
              selected: menuProvider.selectedCategory == categories[index],
              onSelected: (isSelected) {
                menuProvider.selectCategory(categories[index]);
              },
            ),
          );
        },
      ),
    );
  }

  // Food Grid Widget
  Widget _buildFoodGrid(BuildContext context) {
    return Consumer<MenuProvider>(
      builder: (context, menuProvider, child) {
        double screenWidth = MediaQuery.of(context).size.width;
        int crossAxisCount = screenWidth > 600 ? 4 : 2;

        return SizedBox(
          height: screenWidth > 600
              ? MediaQuery.of(context).size.height * 0.6
              : null,  // No fixed height for smaller screens
          child: GridView.builder(
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),  // Allows smooth scrolling
            itemCount: menuProvider.filteredMenuItems.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 3 / 4,
            ),
            itemBuilder: (context, index) {
              final item = menuProvider.filteredMenuItems[index];
              return _buildFoodCard(context, item);
            },
          ),
        );
      },
    );
  }

  // Food Card Widget
  Widget _buildFoodCard(BuildContext context, Map<String, dynamic> item) {
    final menuProvider = Provider.of<MenuProvider>(context);
    bool isFavorite = menuProvider.isFavorite(item['id']);
    bool isInCart = menuProvider.isInCart(item['id']);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 5.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Image and Favorite Button with Splash Animation
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.asset(
                    item['image'],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: InkWell(
                  splashColor: Colors.blue.withOpacity(0.5), // Splash color
                  onTap: () {
                    if (isFavorite) {
                      menuProvider.removeFavorite(item['id']);
                    } else {
                      menuProvider.addFavorite(item['id']);
                    }
                  },
                  child: AnimatedScale(
                    duration: Duration(milliseconds: 300),
                    scale: isFavorite ? 1.5 : 1.0, // Scale the icon when clicked
                    child: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Food Details
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['name'],
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text('₹${item['price']}',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.green)),
                  SizedBox(height: 8),

                  // Scrollable Description
                  Expanded(
                    child: SingleChildScrollView(
                      child: Text(
                        item['description'] ?? 'No description available',
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Add to Cart Button
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: isInCart ? null : () => menuProvider.addToCart(item),
              child: Text(isInCart ? 'In Cart' : 'Add to Cart'),
              style: ElevatedButton.styleFrom(
                backgroundColor: isInCart ? Colors.grey : Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: EdgeInsets.symmetric(vertical: 12.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}