import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/orders.dart';

class OrderScreen extends StatefulWidget {
  static final String routeName = "/orders/";

  const OrderScreen({Key key}) : super(key: key);

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      Provider.of<Orders>(context, listen: false).fetchOrders();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<Orders>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Orders"),
      ),
      body: RefreshIndicator(
        onRefresh: orderProvider.fetchOrders,
        child: ListView.builder(
          itemCount: orderProvider.items.length,
          itemBuilder: (ctx, i) => OrderListItem(
            order: orderProvider.items[i],
          ),
        ),
      ),
    );
  }
}

class OrderListItem extends StatefulWidget {
  final OrderItem order;

  const OrderListItem({
    Key key,
    this.order,
  }) : super(key: key);

  @override
  _OrderListItemState createState() => _OrderListItemState();
}

class _OrderListItemState extends State<OrderListItem> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text('\$${widget.order.amount}'),
            subtitle: Text(
              DateFormat('dd/MM/yyyy hh:mm').format(widget.order.orderTime),
            ),
            trailing: IconButton(
              icon: Icon(_isExpanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
            ),
          ),
          _isExpanded
              ? Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Column(
                    children: widget.order.products
                        .map(
                          (e) => Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 5,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  e.product.title,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text('\$${e.product.price}')
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}

// ListView.builder(
//                 itemCount: widget.order.products.length,
//                 itemBuilder: (ctx, i) =>
//               ),
