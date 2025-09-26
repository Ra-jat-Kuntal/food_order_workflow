import 'package:equatable/equatable.dart';
import '../../models/menu_item.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

class AddItem extends CartEvent {
  final MenuItem item;
  final int quantity;

  const AddItem({required this.item, this.quantity = 1});

  @override
  List<Object?> get props => [item, quantity];
}

class RemoveItem extends CartEvent {
  final String itemId;

  const RemoveItem({required this.itemId});

  @override
  List<Object?> get props => [itemId];
}

class UpdateQuantity extends CartEvent {
  final String itemId;
  final int quantity;

  const UpdateQuantity({required this.itemId, required this.quantity});

  @override
  List<Object?> get props => [itemId, quantity];
}

class Checkout extends CartEvent {
  final String address;
  final String paymentMethod;

  const Checkout({required this.address, this.paymentMethod = 'COD'});

  @override
  List<Object?> get props => [address, paymentMethod];
}

class ClearCart extends CartEvent {}

class ResetStatus extends CartEvent {}
