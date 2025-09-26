part of 'menu_bloc.dart';

abstract class MenuState {}

class MenuInitial extends MenuState {}

class MenuLoading extends MenuState {}

class MenuLoaded extends MenuState {
  final List<MenuItem> menu;
  final Restaurant restaurant;
  MenuLoaded({required this.menu, required this.restaurant});
}

class MenuError extends MenuState {
  final String message;
  MenuError({required this.message});
}
