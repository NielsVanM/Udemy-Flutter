import 'package:flutter/material.dart';
import 'package:meals/dummy_data.dart';
import 'package:meals/models/recipe.dart';
import 'package:meals/screens/category_meals_screen.dart';
import 'package:meals/screens/filters_screen.dart';
import 'package:meals/screens/meal_detail_screen.dart';
import 'package:meals/screens/tabs_screen.dart';

void main() => runApp(MyApp());

// The Main App Theme Data
ThemeData globalTheme = ThemeData(
  primarySwatch: Colors.cyan,
  accentColor: Colors.amber,
  canvasColor: Color.fromRGBO(255, 254, 229, 1),
  fontFamily: 'Raleway',
  textTheme: ThemeData.light().textTheme.copyWith(
        bodyText1: TextStyle(color: Color.fromRGBO(20, 51, 51, 1)),
        bodyText2: TextStyle(color: Color.fromRGBO(20, 51, 51, 1)),
        headline6: TextStyle(
            fontSize: 20,
            fontFamily: 'RobotoCondensed',
            fontWeight: FontWeight.bold),
      ),
);

// The Screen Route Table

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Map<String, bool> _filters = {
    'gluten': false,
    'lactose': false,
    'vegan': false,
    'vegetarian': false,
  };

  List<Meal> _availableMeals = DUMMY_MEALS;
  List<Meal> _favoriteMeals = [];

  void _setFilters(Map<String, bool> filterData) {
    setState(() {
      _filters = filterData;
      print(_filters);

      _availableMeals = DUMMY_MEALS.where((meal) {
        if (_filters['gluten'] == true && !meal.isGlutenFree) return false;
        if (_filters['lactose'] == true && !meal.isLactoseFree) return false;
        if (_filters['vegan'] == true && !meal.isVegan) return false;
        if (_filters['vegetarian'] == true && !meal.isVegetarian) return false;
        return true;
      }).toList();
    });
  }

  void _toggleFavoriteMeal(String mealID) {
    final index = _favoriteMeals.indexWhere((element) => element.id == mealID);
    if (index >= 0) {
      setState(() {
        _favoriteMeals.removeAt(index);
      });
      return;
    }

    setState(() {
      _favoriteMeals.add(
        DUMMY_MEALS.firstWhere((element) => element.id == mealID),
      );
    });
  }

  bool _checkFavorite(String mealID) {
    return _favoriteMeals.any((meal) => meal.id == mealID);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DeliMeals',
      theme: globalTheme,
      routes: {
        "/": (ctx) => TabsScreen(favorites: _favoriteMeals),
        CategoryMealsScreen.routeName: (ctx) =>
            CategoryMealsScreen(availableMeals: _availableMeals),
        MealDetailScreen.routeName: (ctx) => MealDetailScreen(
            favoriteFunc: _toggleFavoriteMeal,
            checkFavoriteFunc: _checkFavorite),
        FiltersScreen.routeName: (ctx) => FiltersScreen(
              setFilters: _setFilters,
              currentFilters: _filters,
            ),
      },
    );
  }
}
