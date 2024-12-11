import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'menu.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final menuProvider = Provider.of<MenuProvider>(context);
    final cartItems = menuProvider.cartItems;

    double totalAmount = 0;
    cartItems.forEach((item) {
      totalAmount += item['price'] * (menuProvider.getItemCount(item['id']));
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
        backgroundColor: Colors.deepOrangeAccent,
        actions: [
          Tooltip(
            message: 'Clear all items',
            child: IconButton(
              icon: Icon(Icons.clear_all),
              onPressed: () {
                menuProvider.clearCart(); // Clear the cart
              },
            ),
          ),
        ],
      ),
      body: cartItems.isEmpty
          ? Center(child: Text('Your cart is empty!'))
          : AnimatedSwitcher(
        duration: Duration(milliseconds: 300),
        child: ListView.builder(
          key: ValueKey<int>(cartItems.length),
          itemCount: cartItems.length,
          itemBuilder: (context, index) {
            final item = cartItems[index];
            final itemCount = menuProvider.getItemCount(item['id']);
            return Card(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: ListTile(
                contentPadding: EdgeInsets.all(15),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    item['image'], // Item image here
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(
                  item['name'],
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  '₹${item['price']} x $itemCount',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove, color: Colors.red),
                      onPressed: () {
                        if (itemCount > 1) {
                          menuProvider.decreaseItemCount(item['id']);
                        } else {
                          menuProvider.removeFromCart(item['id']);
                        }
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.add, color: Colors.green),
                      onPressed: () {
                        menuProvider.increaseItemCount(item['id']);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        height: 80,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.orangeAccent, Colors.deepOrange],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              spreadRadius: 5,
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Center(
          child: Text(
            'Total: ₹${totalAmount.toStringAsFixed(2)}',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      floatingActionButton: Tooltip(
        message: 'Proceed to Payment',
        child: FloatingActionButton(
          backgroundColor: Colors.deepOrangeAccent,
          onPressed: () {
            // Add any action on FAB click (like checkout)
          },
          child: Icon(Icons.payment),
        ),
      ),
    );
  }
}
