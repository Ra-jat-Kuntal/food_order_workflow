import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:food_order_workflow/models/restaurant.dart';
import 'package:food_order_workflow/repository/restaurant_repository.dart';

part 'restaurant_event.dart';
part 'restaurant_state.dart';

class RestaurantBloc extends Bloc<RestaurantEvent, RestaurantState> {
  final RestaurantRepository repository;
  RestaurantBloc({required this.repository}) : super(RestaurantInitial()) {
    on<LoadRestaurants>(_onLoad);
  }

  Future<void> _onLoad(LoadRestaurants event, Emitter<RestaurantState> emit) async {
    emit(RestaurantLoading());
    try {
      final restaurants = await repository.fetchRestaurants();
      emit(RestaurantLoaded(restaurants: restaurants));
    } catch (e) {
      emit(RestaurantError(message: 'Failed to load restaurants'));
    }
  }
}
