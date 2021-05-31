import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/auth.dart';
import 'package:shop/providers/cart.dart';
import 'package:shop/providers/product.dart';
import 'package:shop/providers/products_provider.dart';
import 'package:shop/screen/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  final Product product;

  const ProductItem({Key key, this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Register listener
    Provider.of<Product>(context);

    final cart = Provider.of<Cart>(context);
    final products = Provider.of<Products>(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () => Navigator.of(context)
              .pushNamed(ProductDetailScreen.routeName, arguments: product),
          child: Hero(
            tag: product.id,
            child: FadeInImage(
              placeholder: AssetImage('assets/images/product-placeholder.png'),
              image: NetworkImage(product.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        footer: GridTileBar(
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          backgroundColor: Theme.of(context).primaryColor,
          leading: IconButton(
            icon: Icon(
              product.isFavorite ? Icons.favorite : Icons.favorite_border,
            ),
            onPressed: () => products.toggleFavorite(
              product,
              Provider.of<Auth>(context, listen: false).userID,
            ),
            color: Theme.of(context).accentColor,
          ),
          trailing: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                cart.addItem(product);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Added ${product.title} to your cart."),
                    action: SnackBarAction(
                      label: "Undo",
                      onPressed: () {
                        cart.removeSingleProduct(product);
                      },
                    ),
                  ),
                );
              },
              color: Theme.of(context).accentColor),
        ),
      ),
    );
  }
}
