import 'package:food_order_workflow/models/restaurant.dart';

abstract class RestaurantRepository {
  Future<List<Restaurant>> fetchRestaurants();
  Future<List<Restaurant>> fetchMenuForRestaurant(String restaurantId);
}
