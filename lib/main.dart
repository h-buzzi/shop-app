import 'package:ShoppingProject/helpers/custom_route.dart';
import 'package:ShoppingProject/providers/auth.dart';
import 'package:ShoppingProject/providers/cart_provider.dart';
import 'package:ShoppingProject/providers/orders_provider.dart';
import 'package:ShoppingProject/screens/add_edit_product_screen.dart';
import 'package:ShoppingProject/screens/authentication_screen.dart';
import 'package:ShoppingProject/screens/cart_screen.dart';
import 'package:ShoppingProject/screens/orders_screen.dart';
import 'package:ShoppingProject/screens/product_info_screen.dart';
import 'package:ShoppingProject/screens/products_overview.dart';
import 'package:ShoppingProject/screens/user_products_screen.dart';
import 'package:flutter/material.dart';
import 'package:ShoppingProject/providers/products_providers.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (ctx) => Cart(),
          ),
          ChangeNotifierProvider(
            create: (ctx) => Auth(),
          ),
          ChangeNotifierProxyProvider<Auth, Products>(
            create: (ctx) => Products('', '', []),
            update: (ctx, auth, previousProducts) => Products(
                auth.token,
                auth.userId,
                previousProducts == null ? [] : previousProducts.items),
          ),
          ChangeNotifierProxyProvider<Auth, Orders>(
            create: (ctx) => Orders('', '', []),
            update: (ctx, auth, previousOrders) => Orders(
                auth.token,
                auth.userId,
                previousOrders == null ? [] : previousOrders.orders),
          ),
        ], //if instantiating a object, don't use .value
        //value: Products(),
        child: Consumer<Auth>(
          builder: (ctx, authData, _) {
            return MaterialApp(
              title: 'MyShop',
              theme: ThemeData(
                  primarySwatch: Colors.purple,
                  colorScheme: ThemeData()
                      .colorScheme
                      .copyWith(secondary: Colors.deepOrange),
                  pageTransitionsTheme: PageTransitionsTheme(builders: {
                    TargetPlatform.android: CustomPageTransitionBuilder(),
                    TargetPlatform.iOS: CustomPageTransitionBuilder(),
                  }),
                  fontFamily: 'Lato'),
              home: authData.isAuth
                  ? ProductOverviewScreen()
                  : FutureBuilder(
                      future: authData.tryAutoLogin(),
                      builder: (ctx, authResultSnapshot) =>
                          authResultSnapshot.connectionState ==
                                  ConnectionState.waiting
                              ? Scaffold(
                                  body: Center(
                                    child: Text('Loading...'),
                                  ),
                                )
                              : AuthScreen()),
              routes: {
                ProductOverviewScreen.routeName: (ctx) =>
                    ProductOverviewScreen(),
                ProductInfoScreen.routeName: (ctx) => ProductInfoScreen(),
                CartScreen.routeName: (ctx) => CartScreen(),
                OrderScreen.routeName: (ctx) => OrderScreen(),
                UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
                AddEditProductScreen.routeName: (ctx) => AddEditProductScreen(),
                AuthScreen.routeName: (ctx) => AuthScreen(),
              },
            );
          },
        ));
  }
}
