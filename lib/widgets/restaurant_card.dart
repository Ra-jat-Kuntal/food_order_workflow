import 'package:flutter/material.dart';
import 'package:food_order_workflow/models/restaurant.dart';

class RestaurantCard extends StatelessWidget {
  final Restaurant restaurant;
  const RestaurantCard({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      color: Colors.amber[200],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12),),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.amber,
              radius: 28,
              child: Text(restaurant.name.substring(0, 1)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(restaurant.name, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 4),
                Text(restaurant.description, style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(height: 6),
                Row(children: [
                  Icon(Icons.star, size: 16, color: Colors.amber.shade700),
                  const SizedBox(width: 4),
                  Text('${restaurant.rating}'),
                  const SizedBox(width: 12),
                  Text('Delivery: ₹${restaurant.deliveryFee.toStringAsFixed(0)}'),
                ])
              ]),
            )
          ],
        ),
      ),
    );
  }
}
