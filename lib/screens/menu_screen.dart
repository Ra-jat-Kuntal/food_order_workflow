import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_order_workflow/bloc/cart/cart_bloc.dart';
import 'package:food_order_workflow/models/restaurant.dart';
import 'package:food_order_workflow/widgets/menu_item_card.dart';
import 'package:food_order_workflow/screens/cart_screen.dart';

import '../bloc/cart/cart_event.dart';

class MenuScreen extends StatelessWidget {
  final Restaurant restaurant;
  const MenuScreen({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    // For this mock app we already have menu with restaurant
    final menu = restaurant.menu;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text(restaurant.name),
        actions: [
          IconButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen())),
            icon: const Icon(Icons.shopping_cart),
          )
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: menu.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final item = menu[index];
          return MenuItemCard(
            item: item,
            onAdd: (quantity) {
              context.read<CartBloc>().add(AddItem(item: item, quantity: quantity));
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${item.name} added to cart')));
            },
          );
        },
      ),
    );
  }
}
