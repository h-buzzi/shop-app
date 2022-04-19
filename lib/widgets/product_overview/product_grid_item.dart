import 'package:ShoppingProject/constants.dart';
import 'package:ShoppingProject/providers/auth.dart';
import 'package:ShoppingProject/providers/cart_provider.dart';
import 'package:ShoppingProject/providers/product_class.dart';
import 'package:ShoppingProject/screens/product_info_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductGridItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final loadedGridProduct = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(defaultPadding / 2)),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(ProductInfoScreen.routeName,
                arguments: loadedGridProduct.id);
          },
          child: Hero(
            tag: loadedGridProduct.id,
            child: FadeInImage(
                placeholder:
                    AssetImage('lib/assets/images/product-placeholder.png'),
                image: NetworkImage(loadedGridProduct.imageUrl)),
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: Consumer<Product>(
            //Use consumer when you only wany to recreate a subpart of your widget tree, in this case only the favorite button
            builder: (ctx, loadedGridProduct, child) {
              return IconButton(
                icon: Icon(loadedGridProduct.isFavorite
                    ? Icons.favorite
                    : Icons.favorite_border),
                color: Theme.of(context).colorScheme.secondary,
                onPressed: () {
                  loadedGridProduct.toggleFavoriteStatus(
                      authData.token, authData.userId);
                },
              );
            },
            //child: Text('Never changes'), can refer to this child inside the build via child parameter, to use as a things that shouldn't update
          ),
          title: Text(
            loadedGridProduct.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            color: Theme.of(context).colorScheme.secondary,
            onPressed: () {
              cart.addCartItem(loadedGridProduct.id, loadedGridProduct.price,
                  loadedGridProduct.title);
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Added item to cart!',
                  ),
                  action: SnackBarAction(
                    label: 'UNDO',
                    onPressed: () {
                      cart.removeSingleItem(loadedGridProduct.id);
                    },
                  ),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
