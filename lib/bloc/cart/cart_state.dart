import 'package:equatable/equatable.dart';
import '../../models/cart_item.dart';

enum CartStatus { initial, loading, success, failure }

class CartState extends Equatable {
  final List<CartItem> items;
  final CartStatus status;
  final String? orderId;
  final String? errorMessage;

  const CartState({
    this.items = const [],
    this.status = CartStatus.initial,
    this.orderId,
    this.errorMessage,
  });

  double get subtotal => items.fold(0, (sum, c) => sum + c.total);
  double get deliveryFee => items.isNotEmpty ? 20.0 : 0.0;
  double get total => subtotal + deliveryFee;

  CartState copyWith({
    List<CartItem>? items,
    CartStatus? status,
    String? orderId,
    String? errorMessage,
  }) {
    return CartState(
      items: items ?? this.items,
      status: status ?? this.status,
      orderId: orderId,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [items, status, orderId, errorMessage];
}
