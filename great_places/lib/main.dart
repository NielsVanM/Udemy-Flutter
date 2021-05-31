import 'package:flutter/material.dart';
import 'package:great_places/providers/places.dart';
import 'package:great_places/screens/add_place_screen.dart';
import 'package:great_places/screens/places_list.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

var themeData = ThemeData(
  primarySwatch: Colors.indigo,
  accentColor: Colors.amber,
);

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: PlacesProvider(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: themeData,
        routes: {
          AddPlaceScreen.routeName: (ctx) => AddPlaceScreen(),
        },
        home: PlacesList(),
      ),
    );
  }
}
