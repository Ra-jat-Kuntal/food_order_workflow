import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_order_workflow/bloc/cart/cart_bloc.dart';
import 'package:food_order_workflow/bloc/cart/cart_event.dart';
import 'package:food_order_workflow/bloc/cart/cart_state.dart';
import 'package:food_order_workflow/models/cart_item.dart';
import 'package:food_order_workflow/models/menu_item.dart';

void main() {
  group('CartBloc', () {
    late CartBloc cartBloc;
    final menuItem = MenuItem(id: '1', name: 'Test', description: 't', price: 100);

    setUp(() {
      cartBloc = CartBloc();
    });

    tearDown(() {
      cartBloc.close();
    });

    test('initial state has empty items', () {
      expect(cartBloc.state.items, []);
    });

    blocTest<CartBloc, CartState>(
      'adds item',
      build: () => cartBloc,
      act: (bloc) => bloc.add(AddItem(item: menuItem, quantity: 2)),
      expect: () => [
        CartState(items: [CartItem(item: menuItem, quantity: 2)]),
      ],
      verify: (bloc) {
        expect(bloc.state.items.length, 1);
        expect(bloc.state.items.first.quantity, 2);
        expect(bloc.state.subtotal, 200);
      },
    );

    blocTest<CartBloc, CartState>(
      'updates quantity',
      build: () => cartBloc,
      seed: () => CartState(items: [CartItem(item: menuItem, quantity: 1)]),
      act: (bloc) => bloc.add(UpdateQuantity(itemId: menuItem.id, quantity: 3)),
      expect: () => [
        isA<CartState>(),
      ],
      verify: (bloc) {
        expect(bloc.state.items.first.quantity, 3);
        expect(bloc.state.subtotal, 300);
      },
    );

    blocTest<CartBloc, CartState>(
      'checkout empty cart fails',
      build: () => cartBloc,
      act: (bloc) => bloc.add(Checkout(address: 'addr')),
      expect: () => [isA<CartState>()],
      verify: (bloc) {
        expect(bloc.state.status, CartStatus.failure);
      },
    );
  });
}
