import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/cart/cart_bloc.dart';
import '../bloc/cart/cart_event.dart';
import '../bloc/cart/cart_state.dart';
import '../models/cart_item.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  String _paymentMethod = 'COD';

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final address = _addressController.text.trim();
      context.read<CartBloc>().add(
        Checkout(address: address, paymentMethod: _paymentMethod),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout'), backgroundColor: Colors.amber),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocConsumer<CartBloc, CartState>(
          listener: (context, state) {
            if (state.status == CartStatus.success && state.orderId != null) {
              final itemsCopy = List<CartItem>.from(state.items);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => OrderConfirmationScreen(
                    orderId: state.orderId!,
                    items: itemsCopy,
                  ),
                ),
              ).then((_) {
                context.read<CartBloc>().add(ResetStatus());
              });
            } else if (state.status == CartStatus.failure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.errorMessage ?? 'Error')),
              );
              context.read<CartBloc>().add(ResetStatus());
            }
          },
          builder: (context, state) {
            return Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _addressController,
                    decoration: const InputDecoration(labelText: 'Delivery Address'),
                    validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Please enter address' : null,
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: _paymentMethod,
                    items: const [
                      DropdownMenuItem(value: 'COD', child: Text('Cash on Delivery')),
                      DropdownMenuItem(value: 'UPI', child: Text('UPI (mock)')),
                    ],
                    onChanged: (v) => setState(() => _paymentMethod = v ?? 'COD'),
                    decoration: const InputDecoration(labelText: 'Payment Method'),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: state.status == CartStatus.loading ? null : _submit,
                          child: Container(
                            color: Colors.green,
                            height: 50,
                            width: double.infinity,
                            child: Center(
                              child: state.status == CartStatus.loading
                                  ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                                  : const Text(
                                'Place Order',
                                style: TextStyle(color: Colors.white, fontSize: 18),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (state.status == CartStatus.failure)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Text(
                        state.errorMessage ?? 'Failed',
                        style: const TextStyle(color: Colors.red),
                      ),
                    )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// Temporary OrderConfirmationScreen
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
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Icon(Icons.check_circle, size: 80, color: Colors.green),
            const SizedBox(height: 12),
            Text('Your order is placed!', style: Theme.of(context).textTheme.headlineSmall),
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
                  child: Text('Back to Home', style: TextStyle(color: Colors.white, fontSize: 18)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
