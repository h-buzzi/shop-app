import 'package:ShoppingProject/constants.dart';
import 'package:ShoppingProject/providers/products_providers.dart';
import 'package:ShoppingProject/widgets/product_overview/product_grid_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductsGrid extends StatelessWidget {
  final bool showFavs;
  ProductsGrid(this.showFavs);
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final loadedProducts =
        showFavs ? productsData.favoriteItems : productsData.items;
    return GridView.builder(
        padding: const EdgeInsets.all(defaultPadding),
        itemCount: loadedProducts.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.5,
            crossAxisSpacing: defaultPadding / 2,
            mainAxisSpacing: defaultPadding / 2),
        itemBuilder: (ctx, index) {
          return ChangeNotifierProvider.value(
              //if reusing a instantiated object, .value (and grid/list)
              //create: (context) => loadedProducts[index],
              value: loadedProducts[index],
              child: ProductGridItem());
        });
  }
}
