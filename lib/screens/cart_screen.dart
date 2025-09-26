import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_order_workflow/bloc/cart/cart_bloc.dart';
import 'package:food_order_workflow/screens/checkout_screen.dart';
import 'package:food_order_workflow/widgets/cart_tile.dart';
import '../../models/cart_item.dart';
import '../bloc/cart/cart_event.dart';
import '../bloc/cart/cart_state.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        backgroundColor: Colors.amber,
      ),
      body: BlocConsumer<CartBloc, CartState>(
        listener: (context, state) {
          if (state.status == CartStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage ?? 'Error')),
            );
            context.read<CartBloc>().add(ResetStatus());
          } else if (state.status == CartStatus.success && state.orderId != null) {
            // Navigate to confirmation and pass a copy of items
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => OrderConfirmationScreen(
                  orderId: state.orderId!,
                  items: List<CartItem>.from(state.items),
                ),
              ),
            ).then((_) {
              // Reset status after returning
              context.read<CartBloc>().add(ResetStatus());
            });
          }
        },
        builder: (context, state) {
          if (state.items.isEmpty) {
            return const Center(child: Text('Your cart is empty'));
          }
          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(12),
                  itemCount: state.items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final item = state.items[index];
                    return CartTile(
                      cartItem: item,
                      onRemove: () => context.read<CartBloc>().add(
                          RemoveItem(itemId: item.item.id)),
                      onQuantityChanged: (q) => context.read<CartBloc>().add(
                          UpdateQuantity(itemId: item.item.id, quantity: q)),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Subtotal'),
                        Text('₹${state.subtotal.toStringAsFixed(2)}'),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Delivery'),
                        Text('₹${state.deliveryFee.toStringAsFixed(2)}'),
                      ],
                    ),
                    const Divider(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total', style: Theme.of(context).textTheme.titleLarge),
                        Text('₹${state.total.toStringAsFixed(2)}', style: Theme.of(context).textTheme.titleLarge),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const CheckoutScreen()),
                              );
                            },
                            child: Container(
                              color: Colors.green,
                              height: 50,
                              width: double.infinity,
                              child: const Center(
                                child: Text(
                                  'Proceed to Checkout',
                                  style: TextStyle(color: Colors.white, fontSize: 18),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}




class OrderConfirmationScreen extends StatelessWidget {
  final String orderId;
  final List<CartItem> items;

  const OrderConfirmationScreen({
    super.key,
    required this.orderId,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Order Confirmed')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Icon(Icons.check_circle, size: 80, color: Colors.green),
            const SizedBox(height: 12),
            Text('Your order is placed!',
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text('Order ID: $orderId'),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (_, i) {
                  final it = items[i];
                  return ListTile(
                    title: Text(it.item.name),
                    subtitle: Text('x${it.quantity}'),
                    trailing: Text('₹${it.total.toStringAsFixed(2)}'),
                  );
                },
              ),
            ),
            InkWell(
              onTap: () {
                // Clear cart and reset state before returning home
                final cartBloc = context.read<CartBloc>();
                cartBloc.add(ClearCart());
                cartBloc.add(ResetStatus());
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: Container(
                color: Colors.green,
                height: 50,
                width: double.infinity,
                child: const Center(
                  child: Text('Back to Home',
                      style: TextStyle(color: Colors.white, fontSize: 18)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
