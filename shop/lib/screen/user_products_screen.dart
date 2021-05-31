import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/product.dart';
import 'package:shop/providers/products_provider.dart';
import 'package:shop/screen/product_form_screen.dart';

class UserProductsScreen extends StatelessWidget {
  static const String routeName = "/user_products/";

  const UserProductsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Products productProvider =
        Provider.of<Products>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Products"),
        actions: [
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed(ProductFormScreen.routeName);
              })
        ],
      ),
      body: FutureBuilder(
        future:
            Provider.of<Products>(context, listen: false).fetchProducts(true),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? CircularProgressIndicator()
                : RefreshIndicator(
                    onRefresh: () =>
                        Provider.of<Products>(context, listen: false)
                            .fetchProducts(true),
                    child: Consumer<Products>(
                      builder: (_, productsData, __) => ListView.builder(
                        itemCount: productProvider.items.length,
                        itemBuilder: (ctx, i) => Column(
                          children: [
                            UserProductItem(
                              product: productProvider.items[i],
                            ),
                            Divider(),
                          ],
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}

class UserProductItem extends StatelessWidget {
  final Product product;

  const UserProductItem({Key key, this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(product.title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(product.imageUrl),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              icon: Icon(
                Icons.edit,
                color: Colors.grey,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(
                  ProductFormScreen.routeName,
                  arguments: product,
                );
              },
            ),
            IconButton(
              icon: Icon(
                Icons.delete,
                color: Colors.red,
              ),
              onPressed: () {
                Provider.of<Products>(context, listen: false)
                    .deleteProduct(product.id);
              },
            )
          ],
        ),
      ),
    );
  }
}
