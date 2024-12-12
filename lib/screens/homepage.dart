import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/menu.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(  // Allows scrolling for the entire body
        child: Column(
          children: [
            _buildSearchBar(context),
            _buildCategories(context),
            _buildFoodGrid(context),
          ],
        ),
      ),
    );
  }

  // Search Bar Widget
  Widget _buildSearchBar(BuildContext context) {
    final menuProvider = Provider.of<MenuProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        // Use the search query from the provider to manage the text
        controller: TextEditingController(text: menuProvider.searchQuery)
          ..selection = TextSelection.collapsed(offset: menuProvider.searchQuery.length),
        onChanged: (query) {
          menuProvider.updateSearchQuery(query); // Update query in provider
        },
        decoration: InputDecoration(
          hintText: 'Search for food...',
          prefixIcon: Icon(Icons.search),
          suffixIcon: menuProvider.searchQuery.isNotEmpty // Show clear icon only if there's text
              ? IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              menuProvider.updateSearchQuery('');  // Clear the search query
            },
          )
              : null,
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
        int crossAxisCount = screenWidth > 900
            ? 4
            : screenWidth > 600
            ? 3
            : 2; // Dynamically adjust crossAxisCount

        double childAspectRatio = screenWidth > 600
            ? 2 / 3
            : 3 / 4; // Adjust aspect ratio for tablets and mobile

        return SizedBox(
          height: screenWidth > 600
              ? MediaQuery.of(context).size.height * 0.6
              : null,  // No fixed height for smaller screens
          child: menuProvider.filteredMenuItems.isEmpty
              ? Center(
            child: Text(
              'No items found',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          )
              : GridView.builder(
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),  // Allows smooth scrolling
            itemCount: menuProvider.filteredMenuItems.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: childAspectRatio, // Use dynamic aspect ratio
            ),
            itemBuilder: (context, index) {
              final item = menuProvider.filteredMenuItems[index];
              return _buildFoodCard(context, item);
            },
          ),
        );
      },
    );
  }  Widget _buildFoodDetailDialog(BuildContext context, Map<String, dynamic> item) {
    final menuProvider = Provider.of<MenuProvider>(context);
    bool isFavorite = menuProvider.isFavorite(item['id']);
    bool isInCart = menuProvider.isInCart(item['id']);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Image.asset(
                      item['image'],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 16),

                // Food Name and Price
                Text(
                  item['name'],
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                SizedBox(height: 8),
                Text(
                  '₹${item['price']}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.green),
                ),
                SizedBox(height: 16),

                // Description
                SingleChildScrollView(
                  child: Text(
                    item['description'] ?? 'No description available',
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                    textAlign: TextAlign.justify,
                  ),
                ),
                SizedBox(height: 16),

                // Add to Cart Button
                ElevatedButton(
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
              ],
            ),
          ),

        ],
      ),
    );
  }

  // Food Card Widget
// Food Card Widget
  Widget _buildFoodCard(BuildContext context, Map<String, dynamic> item) {
    final menuProvider = Provider.of<MenuProvider>(context);
    bool isFavorite = menuProvider.isFavorite(item['id']);
    bool isInCart = menuProvider.isInCart(item['id']);

    // Check if the screen width is less than a threshold (e.g., 600px for mobile)
    double screenWidth = MediaQuery.of(context).size.width;
    bool isMobileView = screenWidth < 600;
    bool isTabletView = screenWidth >= 600 && screenWidth < 900;

    // Dynamically adjust aspect ratio and card height based on screen width
    double cardHeight = isMobileView
        ? 250.0 // Default height for mobile
        : isTabletView
        ? 300.0 // Reduced height for tablet view
        : 350.0; // Reduced height for desktop view

    return GestureDetector(
      onTap: isMobileView
          ? () {
        // Open dialog with item details
        showDialog(
          context: context,
          builder: (context) => _buildFoodDetailDialog(context, item),
        );
      }
          : null, // No action for larger screens
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 5.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image and Favorite Button
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
                    splashColor: Colors.blue.withOpacity(0.5),
                    onTap: () {
                      if (isFavorite) {
                        menuProvider.removeFavorite(item['id']);
                      } else {
                        menuProvider.addFavorite(item['id']);
                      }
                    },
                    child: AnimatedScale(
                      duration: Duration(milliseconds: 300),
                      scale: isFavorite ? 1.5 : 1.0,
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Food Name and Price
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['name'],
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '₹${item['price']}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),

            // Hide Description in Mobile View
            if (!isMobileView)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Expanded(
                  child: SingleChildScrollView(
                    child: Text(
                      item['description'] ?? 'No description available',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                ),
              ),

            // Spacer to push the button to the bottom
            Spacer(),

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
      ),
    );
  }}