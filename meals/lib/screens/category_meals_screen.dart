import 'package:flutter/material.dart';
import 'package:meals/models/categories.dart';

import 'package:meals/dummy_data.dart';
import 'package:meals/models/recipe.dart';
import 'package:meals/widgets/meal.dart';

class CategoryMealsScreen extends StatefulWidget {
  static const routeName = "/category_meals/";
  final List<Meal> availableMeals;

  const CategoryMealsScreen({Key key, this.availableMeals}) : super(key: key);

  @override
  _CategoryMealsScreenState createState() => _CategoryMealsScreenState();
}

class _CategoryMealsScreenState extends State<CategoryMealsScreen> {
  Category categorie;
  List<Meal> filteredMeals;
  bool _loadedInitData = false;

  @override
  void didChangeDependencies() {
    if (!_loadedInitData) {
      categorie = ModalRoute.of(context).settings.arguments as Category;
      filteredMeals = widget.availableMeals.where(
        (element) {
          return element.categories.contains(categorie.id);
        },
      ).toList();

      _loadedInitData = true;
    }

    super.didChangeDependencies();
  }

  void _removeMealFromList(String mealID) {
    setState(() {
      filteredMeals.removeWhere((element) => element.id == mealID);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${this.categorie.title} Recipes"),
      ),
      body: ListView.builder(
        itemBuilder: (ctx, i) {
          return MealItem(meal: filteredMeals[i]);
        },
        itemCount: filteredMeals.length,
      ),
    );
  }
}
