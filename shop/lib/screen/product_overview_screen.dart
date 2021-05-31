import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/auth.dart';
import 'package:shop/providers/cart.dart';
import 'package:shop/providers/products_provider.dart';
import 'package:shop/screen/cart_screen.dart';
import 'package:shop/screen/orders_screen.dart';
import 'package:shop/screen/user_products_screen.dart';
import 'package:shop/widgets/badge.dart';
import 'package:shop/widgets/product_item.dart';

enum FilterOptions { Favorites, All }

class ProductsOverviewScreen extends StatefulWidget {
  static const String routeName = "/products/";

  ProductsOverviewScreen({Key key}) : super(key: key);

  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  bool _showOnlyFavorites = false;
  bool _isLoadingProducts = false;

  @override
  void initState() {
    setState(() {
      _isLoadingProducts = true;
    });
    Future.delayed(Duration.zero)
        .then((value) =>
            Provider.of<Products>(context, listen: false).fetchProducts())
        .then((value) => setState(() {
              _isLoadingProducts = false;
            }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop Catalog'),
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text("Only Favorites"),
                value: FilterOptions.Favorites,
              ),
              PopupMenuItem(
                child: Text("Show All"),
                value: FilterOptions.All,
              ),
            ],
            onSelected: (selVal) {
              setState(() {
                switch (selVal) {
                  case FilterOptions.Favorites:
                    _showOnlyFavorites = true;
                    break;
                  case FilterOptions.All:
                    _showOnlyFavorites = false;
                    break;
                }
              });
            },
          ),
          Consumer<Cart>(
            builder: (_, cart, child) => Badge(
              value: cart.count.toString(),
              color: Colors.red,
              child: child,
            ),
            child: IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          )
        ],
      ),
      drawer: Drawer(
        elevation: 5,
        child: ListView(
          children: [
            DrawerHeader(
              child: Text(
                "Shop Navigation",
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            ListTile(
              leading: Icon(Icons.shopping_bag),
              title: Text("Shop"),
              onTap: () {
                Navigator.of(context).pushReplacementNamed("/");
              },
            ),
            ListTile(
              leading: Icon(Icons.list_alt),
              title: Text("Orders"),
              onTap: () {
                Navigator.of(context).pushNamed(OrderScreen.routeName);
              },
            ),
            ListTile(
              leading: Icon(Icons.edit),
              title: Text("Manage Products"),
              onTap: () {
                Navigator.of(context).pushNamed(UserProductsScreen.routeName);
              },
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text("Logout"),
              onTap: () {
                Provider.of<Auth>(context, listen: false).logout();
              },
            ),
          ],
        ),
      ),
      body: _isLoadingProducts
          ? CircularProgressIndicator()
          : ProductsGrid(showFavs: _showOnlyFavorites),
    );
  }
}

class ProductsGrid extends StatelessWidget {
  final bool showFavs;

  const ProductsGrid({
    Key key,
    this.showFavs,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<Products>(context);
    final products =
        showFavs ? productProvider.favoriteItems : productProvider.items;

    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: products.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: products[i],
        child: ProductItem(
          product: products[i],
        ),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 5,
        mainAxisSpacing: 20,
      ),
    );
  }
}
