import 'menu_item.dart';

class Restaurant {
  final String id;
  final String name;
  final String description;
  final List<MenuItem> menu;
  final double deliveryFee;
  final double rating;

  Restaurant({
    required this.id,
    required this.name,
    required this.description,
    required this.menu,
    required this.deliveryFee,
    required this.rating,
  });
}
