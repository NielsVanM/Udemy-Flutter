import 'package:flutter/material.dart';
import 'package:meals/models/recipe.dart';
import 'package:meals/screens/categories_screen.dart';
import 'package:meals/screens/favorites_screen.dart';
import 'package:meals/widgets/maindrawer.dart';

class TabsScreen extends StatefulWidget {
  final List<Meal> favorites;

  TabsScreen({Key key, this.favorites}) : super(key: key);

  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  List<PageInfo> _pages;

  @override
  void initState() {
    _pages = [
      PageInfo(
        page: CategoriesScreen(),
        icon: Icons.category,
        title: "Recipe Caregories",
      ),
      PageInfo(
        page: FavoritesScreen(favorites: widget.favorites),
        icon: Icons.favorite,
        title: "Favorites",
      )
    ];

    super.initState();
  }

  int _selectedPage = 0;

  void _selectPage(int newPageIndex) {
    setState(() {
      _selectedPage = newPageIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_pages[_selectedPage].title),
      ),
      drawer: MainDrawer(),
      body: _pages[_selectedPage].page,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.white,
        selectedItemColor: Theme.of(context).accentColor,
        currentIndex: _selectedPage,
        onTap: _selectPage,
        type: BottomNavigationBarType.shifting,
        items: _pages
            .map(
              (e) => BottomNavigationBarItem(
                icon: Icon(e.icon),
                label: e.title,
                backgroundColor: Theme.of(context).primaryColor,
              ),
            )
            .toList(),
      ),
    );
  }
}

class PageInfo {
  Widget page;
  String title;
  IconData icon;

  PageInfo({this.page, this.title, this.icon});
}
