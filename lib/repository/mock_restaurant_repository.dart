import 'dart:async';
import 'package:uuid/uuid.dart';
import 'restaurant_repository.dart';
import 'package:food_order_workflow/models/restaurant.dart';
import 'package:food_order_workflow/models/menu_item.dart';

class MockRestaurantRepository implements RestaurantRepository {
  final _uuid = const Uuid();

  @override
  Future<List<Restaurant>> fetchRestaurants() async {
    await Future.delayed(const Duration(milliseconds: 600)); // simulate latency
    // In a real repo you'd make network calls
    final restaurants = [
      Restaurant(
        id: _uuid.v4(),
        name: 'Spice Garden',
        description: 'Authentic Indian flavors.',
        menu: _menuFor('Spice Garden'),
        deliveryFee: 20,
        rating: 4.5,
      ),
      Restaurant(
        id: _uuid.v4(),
        name: 'Pasta Palace',
        description: 'Italian classics and pasta bowls.',
        menu: _menuFor('Pasta Palace'),
        deliveryFee: 30,
        rating: 4.3,
      ),
      Restaurant(
        id: _uuid.v4(),
        name: 'Veggie Delight',
        description: 'Fresh vegetarian options.',
        menu: _menuFor('Veggie Delight'),
        deliveryFee: 15,
        rating: 4.7,
      ),
    ];
    return restaurants;
  }

  @override
  Future<List<Restaurant>> fetchMenuForRestaurant(String restaurantId) async {
    // For mock, return restaurants and find by id
    final restaurants = await fetchRestaurants();
    return restaurants.where((r) => r.id == restaurantId).toList();
  }

  List<MenuItem> _menuFor(String restaurant) {
    final base = [
      MenuItem(id: _uuid.v4(), name: 'Margherita', description: 'Classic cheese pizza', price: 200),
      MenuItem(id: _uuid.v4(), name: 'Paneer Butter Masala', description: 'Creamy paneer curry', price: 180),
      MenuItem(id: _uuid.v4(), name: 'Garlic Bread', description: 'Toasted garlic bread', price: 60),
      MenuItem(id: _uuid.v4(), name: 'Caesar Salad', description: 'Fresh greens with dressing', price: 120),
      MenuItem(id: _uuid.v4(), name: 'Veg Biryani', description: 'Spiced rice with vegetables', price: 150),
      MenuItem(id: _uuid.v4(), name: 'Pasta Alfredo', description: 'Creamy alfredo pasta', price: 210),
    ];
    // pick a subset depending on restaurant name to vary menus
    base.shuffle();
    return base.take(4).toList();
  }
}
