import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product(
      {@required this.id,
      @required this.title,
      @required this.description,
      @required this.price,
      @required this.imageUrl,
      this.isFavorite = false});

  void toggleFavoriteStatus(String token, String userId) async {
    final oldStatus = isFavorite == null ? false : isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    try {
      final response = await http.put(
          Uri.parse(
              'https://flutter-shop-heb2022-default-rtdb.firebaseio.com/userFavorites/$userId/$id.json?auth=$token'),
          body: json.encode(isFavorite));
      if (response.statusCode >= 400) {
        isFavorite = oldStatus;
        notifyListeners();
      }
    } catch (e) {
      isFavorite = oldStatus;
      notifyListeners();
    }
  }

  Product copyWith(
          {String id,
          String title,
          String description,
          double price,
          String imageUrl,
          bool isFavorite}) =>
      Product(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        price: price ?? this.price,
        imageUrl: imageUrl ?? this.imageUrl,
        isFavorite: isFavorite ?? this.isFavorite,
      );
}
