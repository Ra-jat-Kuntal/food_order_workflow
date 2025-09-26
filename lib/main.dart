import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_order_workflow/repository/mock_restaurant_repository.dart';
import 'package:food_order_workflow/repository/restaurant_repository.dart';
import 'package:food_order_workflow/screens/restaurant_list_screen.dart';
import 'package:food_order_workflow/bloc/cart/cart_bloc.dart';
import 'package:food_order_workflow/bloc/restaurant/restaurant_bloc.dart';
import 'package:food_order_workflow/bloc/menu/menu_bloc.dart';

void main() {
  final RestaurantRepository repository = MockRestaurantRepository();
  runApp(MyApp(repository: repository));
}

class MyApp extends StatelessWidget {
  final RestaurantRepository repository;
  const MyApp({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<RestaurantBloc>(
          create: (context) => RestaurantBloc(repository: repository)..add(LoadRestaurants()),
        ),
        BlocProvider<MenuBloc>(
          create: (context) => MenuBloc(repository: repository),
        ),
        BlocProvider<CartBloc>(
          create: (context) => CartBloc(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Food Order Workflow',
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Colors.deepOrange,
        ),
        home: const RestaurantListScreen(),
      ),
    );
  }
}
