import 'package:ShoppingProject/constants.dart';
import 'package:ShoppingProject/providers/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShoppingCartItem extends StatelessWidget {
  final String id;
  final String productId;
  final double price;
  final int quantity;
  final String title;

  ShoppingCartItem(
      {@required this.id,
      @required this.price,
      @required this.quantity,
      @required this.title,
      @required this.productId});
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Are you sure?'),
            content: Text('Do you want to remove the item from the cart?'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop(false);
                  },
                  child: Text('No')),
              TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop(true);
                  },
                  child: Text('Yes'))
            ],
          ),
        );
      },
      key: ValueKey(id),
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(productId);
      },
      direction: DismissDirection.endToStart,
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        margin: EdgeInsets.symmetric(
            horizontal: defaultPadding, vertical: defaultPadding / 4),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: defaultPadding * 1.25),
      ),
      child: Card(
        margin: EdgeInsets.symmetric(
            horizontal: defaultPadding, vertical: defaultPadding / 4),
        child: Padding(
          padding: EdgeInsets.all(defaultPadding / 2),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: const EdgeInsets.all(defaultPadding / 4),
                child: FittedBox(child: Text('\$$price')),
              ),
            ),
            title: Text(title),
            subtitle: Text('Total: \$${price * quantity}'),
            trailing: Text('$quantity x'),
          ),
        ),
      ),
    );
  }
}
