import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/cart.dart';
import 'package:shop/providers/orders.dart';

class CartScreen extends StatelessWidget {
  static String routeName = "/cart/";

  const CartScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Cart cart = Provider.of<Cart>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text("Your Cart"),
        ),
        body: Column(
          children: [
            Card(
              margin: EdgeInsets.all(15),
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Total", style: TextStyle(fontSize: 20)),
                    Spacer(),
                    Chip(
                      label: Text(
                        "\$${cart.totalPrice.toStringAsFixed(2)}",
                        style: TextStyle(
                          color: Theme.of(context).textTheme.headline6.color,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Provider.of<Orders>(context, listen: false).addOrder(
                          cart.items,
                          cart.totalPrice,
                        );
                        cart.emptyCart();
                      },
                      child: Text(
                        "ORDER NOW",
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemBuilder: (ctx, i) => CartListItem(
                  cartItem: cart.items[i],
                ),
                itemCount: cart.count,
              ),
            ),
          ],
        ));
  }
}

class CartListItem extends StatelessWidget {
  final CartItem cartItem;

  const CartListItem({Key key, this.cartItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(cartItem),
      background: Container(
        color: Colors.red,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) {
        return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Are you sure?"),
            content: Text(
                "You are about to remove ${cartItem.product.title} from your cart."),
            actions: [
              TextButton(
                child: Text("Cancel"),
                onPressed: () {
                  Navigator.pop(context, false);
                },
              ),
              TextButton(
                child: Text("Confirm"),
                onPressed: () {
                  Navigator.pop(context, true);
                },
              ),
            ],
          ),
        );
      },
      onDismissed: (_) {
        Provider.of<Cart>(context, listen: false).removeFullItem(cartItem);
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: FittedBox(child: Text('\$${cartItem.product.price}')),
            ),
            title: Text(cartItem.product.title),
            subtitle:
                Text('Total: \$${cartItem.totalPrice.toStringAsFixed(2)}'),
            trailing: Text('${cartItem.quantity}x'),
          ),
        ),
      ),
    );
  }
}
