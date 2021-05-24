import 'package:flutter/material.dart';
import 'package:meals/models/recipe.dart';

class MealDetailScreen extends StatelessWidget {
  static final routeName = "/meal_detail/";
  final Function favoriteFunc;
  final Function checkFavoriteFunc;

  const MealDetailScreen({Key key, this.favoriteFunc, this.checkFavoriteFunc})
      : super(key: key);

  Widget _buildSectionTitle(String title, BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Text(
        title,
        style: Theme.of(context).textTheme.headline6,
      ),
    );
  }

  Widget _buildContainer({Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      height: 200,
      width: 300,
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.all(10),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final Meal meal = ModalRoute.of(context).settings.arguments as Meal;

    return Scaffold(
      appBar: AppBar(
        title: Text("${meal.title}"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 300,
              width: double.infinity,
              child: Image.network(
                meal.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            _buildSectionTitle("Ingredients", context),
            _buildContainer(
              child: ListView.builder(
                itemBuilder: (ctx, i) => Card(
                  color: Theme.of(context).accentColor,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: Text(meal.ingredients[i]),
                  ),
                ),
                itemCount: meal.ingredients.length,
              ),
            ),
            Divider(
              color: Colors.black,
            ),
            _buildSectionTitle("Steps:", context),
            _buildContainer(
                child: ListView.builder(
              itemBuilder: (ctx, i) => ListTile(
                leading: CircleAvatar(child: Text("${i + 1}")),
                title: Text(meal.steps[i]),
              ),
              itemCount: meal.steps.length,
            ))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child:
            Icon(checkFavoriteFunc(meal.id) ? Icons.star : Icons.star_border),
        onPressed: () => favoriteFunc(meal.id),
      ),
    );
  }
}
