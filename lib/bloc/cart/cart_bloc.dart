import 'package:bloc/bloc.dart';
import 'cart_event.dart';
import 'cart_state.dart';
import '../../models/cart_item.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(const CartState()) {
    on<AddItem>(_onAddItem);
    on<RemoveItem>(_onRemoveItem);
    on<UpdateQuantity>(_onUpdateQuantity);
    on<Checkout>(_onCheckout);
    on<ClearCart>(_onClearCart);
    on<ResetStatus>(_onResetStatus);
  }

  void _onAddItem(AddItem event, Emitter<CartState> emit) {
    final items = List<CartItem>.from(state.items);
    final index = items.indexWhere((c) => c.item.id == event.item.id);

    if (index >= 0) {
      items[index] = items[index].copyWith(
        quantity: items[index].quantity + event.quantity,
      );
    } else {
      items.add(CartItem(item: event.item, quantity: event.quantity));
    }

    emit(state.copyWith(items: items, status: CartStatus.initial));
  }

  void _onRemoveItem(RemoveItem event, Emitter<CartState> emit) {
    final items = state.items.where((c) => c.item.id != event.itemId).toList();
    emit(state.copyWith(items: items, status: CartStatus.initial));
  }

  void _onUpdateQuantity(UpdateQuantity event, Emitter<CartState> emit) {
    final items = List<CartItem>.from(state.items);
    final index = items.indexWhere((c) => c.item.id == event.itemId);

    if (index >= 0) {
      items[index] = items[index].copyWith(quantity: event.quantity);
    }

    emit(state.copyWith(items: items, status: CartStatus.initial));
  }

  void _onCheckout(Checkout event, Emitter<CartState> emit) async {
    if (state.items.isEmpty) {
      emit(state.copyWith(
        status: CartStatus.failure,
        errorMessage: "Cart is empty",
      ));
      return;
    }

    emit(state.copyWith(status: CartStatus.loading));

    await Future.delayed(const Duration(seconds: 1)); // simulate network

    print('Payment method: ${event.paymentMethod}');

    final orderId = DateTime.now().millisecondsSinceEpoch.toString();
    emit(state.copyWith(status: CartStatus.success, orderId: orderId));
  }

  void _onClearCart(ClearCart event, Emitter<CartState> emit) {
    emit(state.copyWith(items: [], status: CartStatus.initial, orderId: null));
  }

  void _onResetStatus(ResetStatus event, Emitter<CartState> emit) {
    emit(state.copyWith(status: CartStatus.initial, orderId: null));
  }
}
