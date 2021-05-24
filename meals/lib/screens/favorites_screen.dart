import 'package:flutter/material.dart';
import 'package:meals/models/recipe.dart';
import 'package:meals/widgets/meal.dart';

class FavoritesScreen extends StatelessWidget {
  final List<Meal> favorites;

  const FavoritesScreen({Key key, this.favorites}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (favorites.isEmpty) {
      return Center(
        child: Text(
            "You have no favorites yet! Use the favorites button next to a recipe to create one!"),
      );
    } else {
      return ListView.builder(
        itemBuilder: (ctx, i) {
          return MealItem(meal: favorites[i]);
        },
        itemCount: favorites.length,
      );
    }
  }
}
