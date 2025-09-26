import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:food_order_workflow/models/menu_item.dart';
import 'package:food_order_workflow/models/restaurant.dart';
import 'package:food_order_workflow/repository/restaurant_repository.dart';

part 'menu_event.dart';
part 'menu_state.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  final RestaurantRepository repository;
  MenuBloc({required this.repository}) : super(MenuInitial()) {
    on<LoadMenu>(_onLoadMenu);
  }

  Future<void> _onLoadMenu(LoadMenu event, Emitter<MenuState> emit) async {
    emit(MenuLoading());
    try {
      // Using repository to fetch restaurants (mock). In real app you'd fetch menu by ID
      final restaurants = await repository.fetchRestaurants();
      final match = restaurants.firstWhere((r) => r.id == event.restaurantId, orElse: () => throw Exception('not found'));
      emit(MenuLoaded(menu: match.menu, restaurant: match));
    } catch (e) {
      emit(MenuError(message: 'Failed to load menu'));
    }
  }
}
