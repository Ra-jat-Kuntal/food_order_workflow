import 'package:flutter/material.dart';
import 'package:food_order_workflow/models/menu_item.dart';

class MenuItemCard extends StatefulWidget {
  final MenuItem item;
  final void Function(int quantity) onAdd;
  const MenuItemCard({super.key, required this.item, required this.onAdd});

  @override
  State<MenuItemCard> createState() => _MenuItemCardState();
}

class _MenuItemCardState extends State<MenuItemCard> {
  int qty = 1;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.amber[200],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            const FlutterLogo(size: 56),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(widget.item.name, style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 4),
                Text(widget.item.description, style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(height: 8),
                Text('₹${widget.item.price.toStringAsFixed(2)}'),
              ]),
            ),
            Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      color: Colors.red,
                      onPressed: qty > 1 ? () => setState(() => qty--) : null,
                      icon: const Icon(Icons.remove),
                    ),
                    Text('$qty'),
                    IconButton(
                      color: Colors.green,
                      onPressed: () => setState(() => qty++),
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () => widget.onAdd(qty),
                  child: const Text('Add'),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
