import 'package:ShoppingProject/constants.dart';
import 'package:ShoppingProject/providers/cart_provider.dart' show Cart;
import 'package:ShoppingProject/widgets/cart/cart_total_info.dart';
import 'package:ShoppingProject/widgets/cart/shopping_cart_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Column(
        children: [
          CartTotalInfo(),
          SizedBox(
            height: defaultPadding * 0.75,
          ),
          Consumer<Cart>(
            builder: (_, cart, child) => Expanded(
              child: ListView.builder(
                  itemCount: cart.items.length,
                  itemBuilder: (ctx, index) => ShoppingCartItem(
                        id: cart.items.values.toList()[index].id,
                        price: cart.items.values.toList()[index].price,
                        quantity: cart.items.values.toList()[index].quantity,
                        title: cart.items.values.toList()[index].title,
                        productId: cart.items.keys.toList()[index],
                      )),
            ),
          )
        ],
      ),
    );
  }
}
