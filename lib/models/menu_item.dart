import 'package:equatable/equatable.dart';

class MenuItem extends Equatable {
  final String id;
  final String name;
  final String description;
  final double price;

  const MenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
  });

  @override
  List<Object?> get props => [id, name, description, price];
}
