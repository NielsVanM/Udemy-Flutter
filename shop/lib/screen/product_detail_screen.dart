import 'package:flutter/material.dart';
import 'package:shop/providers/product.dart';

class ProductDetailScreen extends StatelessWidget {
  static String routeName = "/product_detail/";

  const ProductDetailScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final product = ModalRoute.of(context).settings.arguments as Product;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(product.title),
              background: Hero(
                tag: product.id,
                child: Image.network(product.imageUrl, fit: BoxFit.cover),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                SizedBox(height: 10),
                Text(
                  "\$" + product.price.toStringAsFixed(2),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    product.description,
                    textAlign: TextAlign.center,
                    softWrap: true,
                  ),
                ),
                SizedBox(height: 800)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
