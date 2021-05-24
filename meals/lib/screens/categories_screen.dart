import 'package:flutter/material.dart';
import 'package:meals/widgets/category.dart';
import 'package:meals/dummy_data.dart';

class CategoriesScreen extends StatelessWidget {
  static const routeName = "/";

  const CategoriesScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView(
      padding: const EdgeInsets.all(20),
      children: DUMMY_CATEGORIES
          .map((e) => CategoryItem(
                category: e,
              ))
          .toList(),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
      ),
    );
  }
}
