import 'dart:math';

import 'package:ShoppingProject/constants.dart';
import 'package:ShoppingProject/providers/orders_provider.dart' show Orders;
import 'package:ShoppingProject/widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class OrderScreen extends StatefulWidget {
  static const routeName = '/orders';

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  Future _ordersFuture;

  Future _obtainOrdersFuture() {
    return Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
  }

  @override
  void initState() {
    _ordersFuture = _obtainOrdersFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //final ordersData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _ordersFuture,
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (dataSnapshot.error != null) {
              return Center(
                child: Text('An error occurrer'),
              );
            } else {
              return Consumer<Orders>(
                builder: (ctx, ordersData, child) => ListView.builder(
                  itemCount: ordersData.orders.length,
                  itemBuilder: (_, i) {
                    return OrderCard(ordersData: ordersData, index: i);
                  },
                ),
              );
            }
          }
        },
      ),
    );
  }
}

class OrderCard extends StatefulWidget {
  const OrderCard({
    Key key,
    @required this.ordersData,
    @required this.index,
  }) : super(key: key);

  final Orders ordersData;
  final int index;

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  var _expanded = false;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: _expanded
          ? min(
              widget.ordersData.orders[widget.index].products.length * 20.0 +
                  120,
              210)
          : 100,
      child: Card(
        margin: EdgeInsets.all(defaultPadding * 0.75),
        child: Column(
          children: [
            ListTile(
              title: Text('\$${widget.ordersData.orders[widget.index].amount}'),
              subtitle: Text(DateFormat('dd/MM/yyyy  hh:mm')
                  .format(widget.ordersData.orders[widget.index].dateTime)),
              trailing: IconButton(
                icon: Icon(
                  _expanded ? Icons.expand_less : Icons.expand_more,
                ),
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
              ),
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              height: _expanded
                  ? min(
                      widget.ordersData.orders[widget.index].products.length *
                              20.0 +
                          10,
                      100)
                  : 0,
              padding: EdgeInsets.symmetric(
                  horizontal: defaultPadding / 2, vertical: defaultPadding / 4),
              child: ListView(
                children: widget.ordersData.orders[widget.index].products
                    .map((prod) => Row(
                          children: [
                            Text(
                              prod.title,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Spacer(),
                            Text('${prod.quantity}x \$${prod.price}'),
                          ],
                        ))
                    .toList(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
