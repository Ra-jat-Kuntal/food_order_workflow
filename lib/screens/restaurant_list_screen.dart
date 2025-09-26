import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_order_workflow/bloc/restaurant/restaurant_bloc.dart';
import 'package:food_order_workflow/screens/menu_screen.dart';
import 'package:food_order_workflow/widgets/restaurant_card.dart';

class RestaurantListScreen extends StatelessWidget {
  const RestaurantListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Local Restaurants'), backgroundColor: Colors.amber,),
      body: BlocBuilder<RestaurantBloc, RestaurantState>(
        builder: (context, state) {
          if (state is RestaurantLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is RestaurantLoaded) {
            final restaurants = state.restaurants;
            return ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: restaurants.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final r = restaurants[index];
                return GestureDetector(
                  onTap: () {
                    // navigate to menu
                    Navigator.push(context, MaterialPageRoute(builder: (_) => MenuScreen(restaurant: r)));
                  },
                  child: RestaurantCard(restaurant: r),
                );
              },
            );
          } else if (state is RestaurantError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => context.read<RestaurantBloc>().add(LoadRestaurants()),
                    child: const Text('Retry'),
                  )
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
