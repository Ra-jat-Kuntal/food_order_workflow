import 'package:equatable/equatable.dart';
import 'menu_item.dart';

class CartItem extends Equatable {
  final MenuItem item;
  final int quantity;

  const CartItem({required this.item, required this.quantity});

  double get total => item.price * quantity;

  CartItem copyWith({MenuItem? item, int? quantity}) {
    return CartItem(
      item: item ?? this.item,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  List<Object?> get props => [item, quantity];
}
