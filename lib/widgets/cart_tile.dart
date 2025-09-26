import 'package:flutter/material.dart';
import 'package:food_order_workflow/models/cart_item.dart';

class CartTile extends StatelessWidget {
  final CartItem cartItem;
  final VoidCallback onRemove;
  final void Function(int) onQuantityChanged;

  const CartTile({super.key, required this.cartItem, required this.onRemove, required this.onQuantityChanged});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const FlutterLogo(),
      title: Text(cartItem.item.name),
      subtitle: Text('₹${cartItem.item.price.toStringAsFixed(2)}'),
      trailing: SizedBox(
        width: 140,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(onPressed: () => onQuantityChanged(cartItem.quantity - 1), icon: const Icon(Icons.remove)),
            Text('${cartItem.quantity}'),
            IconButton(onPressed: () => onQuantityChanged(cartItem.quantity + 1), icon: const Icon(Icons.add)),
            IconButton(onPressed: onRemove, icon: const Icon(Icons.delete),color: Colors.red,),
          ],
        ),
      ),
    );
  }
}
