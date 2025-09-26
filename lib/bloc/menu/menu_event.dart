part of 'menu_bloc.dart';

abstract class MenuEvent {}

class LoadMenu extends MenuEvent {
  final String restaurantId;
  LoadMenu({required this.restaurantId});
}
