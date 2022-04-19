import 'package:ShoppingProject/constants.dart';
import 'package:ShoppingProject/providers/cart_provider.dart';
import 'package:ShoppingProject/providers/orders_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartTotalInfo extends StatelessWidget {
  const CartTotalInfo({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Card(
      margin: EdgeInsets.all(defaultPadding),
      child: Padding(
        padding: EdgeInsets.all(defaultPadding / 2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total',
              style: TextStyle(fontSize: 20),
            ),
            Spacer(),
            Chip(
              label: Text(
                '\$${cart.totalAmount.toStringAsFixed(2)}',
                style: TextStyle(
                    color: Theme.of(context).primaryTextTheme.headline6.color),
              ),
              backgroundColor: Theme.of(context).primaryColor,
            ),
            OrderButton(cart: cart)
          ],
        ),
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: _isLoading
          ? CircularProgressIndicator()
          : Text(
              'ORDER NOW',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
      onPressed: (widget.cart.totalAmount <= 0 || _isLoading)
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              await Provider.of<Orders>(context, listen: false).addOrder(
                  widget.cart.items.values.toList(), widget.cart.totalAmount);
              widget.cart.clear();
              setState(() {
                _isLoading = false;
              });
            },
    );
  }
}
