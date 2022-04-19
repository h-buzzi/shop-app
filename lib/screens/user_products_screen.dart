import 'package:ShoppingProject/constants.dart';
import 'package:ShoppingProject/providers/product_class.dart';
import 'package:ShoppingProject/providers/products_providers.dart';
import 'package:ShoppingProject/screens/add_edit_product_screen.dart';
import 'package:ShoppingProject/widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products-screen';
  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .fetchAndSetProductsList(true);
  }

  @override
  Widget build(BuildContext context) {
    print('rebuilding...');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('Your Products'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(AddEditProductScreen.routeName);
            },
            icon: const Icon(Icons.add),
          )
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => _refreshProducts(context),
                    child: Consumer<Products>(
                      builder: (context, productsData, child) => Padding(
                        padding: EdgeInsets.all(defaultPadding / 2),
                        child: ListView.builder(
                          itemCount: productsData.items.length,
                          itemBuilder: (ctx, i) => Column(
                            children: [
                              UserProductListTile(
                                productData: productsData.items[i],
                                delete: productsData.deleteProduct,
                              ),
                              Divider()
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}

class UserProductListTile extends StatelessWidget {
  const UserProductListTile(
      {Key key, @required this.productData, @required this.delete})
      : super(key: key);

  final Product productData;
  final Function delete;

  @override
  Widget build(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    return ListTile(
      title: Text(productData.title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(productData.imageUrl),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(AddEditProductScreen.routeName,
                  arguments: productData.id);
            },
            icon: Icon(Icons.edit),
            color: Theme.of(context).primaryColor,
          ),
          IconButton(
            onPressed: () async {
              try {
                await delete(productData.id);
              } catch (error) {
                scaffold.showSnackBar(SnackBar(
                    content: Text(
                  'Deleting Failed!',
                  textAlign: TextAlign.center,
                )));
              }
            },
            icon: Icon(Icons.delete),
            color: Theme.of(context).errorColor,
          ),
        ],
      ),
    );
  }
}
