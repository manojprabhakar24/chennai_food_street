import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/menu.dart';

class FavoritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final menuProvider = Provider.of<MenuProvider>(context);
    final favoriteItems = menuProvider.favoriteItems;

    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
        backgroundColor: Colors.grey,
      ),
      body: favoriteItems.isEmpty
          ? Center(child: Text('No favorites yet', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)))
          : ListView.builder(
        itemCount: favoriteItems.length,
        itemBuilder: (context, index) {
          final itemId = favoriteItems[index];
          final item = menuProvider.menuItems.firstWhere((item) => item['id'] == itemId);

          return AnimatedSwitcher(
            duration: Duration(milliseconds: 300),
            child: Card(
              key: ValueKey<int>(itemId),
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: InkWell(
                onTap: () {
                  // You can define actions for the card click here (e.g., show item details)
                },
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      // Item Image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          item['image'],
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: 15),
                      // Item Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['name'],
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8),
                            Text(
                              '₹${item['price']}',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.green),
                            ),
                            SizedBox(height: 8),
                            Text(
                              item['description'] ?? 'No description available',
                              style: TextStyle(color: Colors.grey[700], fontSize: 14),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      // Favorite Icon Button (like/unlike)
                      IconButton(
                        icon: Icon(
                          menuProvider.isFavorite(item['id']) ? Icons.favorite : Icons.favorite_border,
                          color: menuProvider.isFavorite(item['id']) ? Colors.red : Colors.grey,
                        ),
                        onPressed: () {
                          menuProvider.toggleFavorite(item['id']);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
