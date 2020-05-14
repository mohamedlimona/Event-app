import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Event with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final String datetime;
final String creatorId;
  final String imageUrl;
  final String barcodeurl;
  bool isFavorite;

  Event({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.datetime,
this.creatorId,
    @required this.imageUrl,
    @required this.barcodeurl,
    this.isFavorite = false,
  });

  void _setFavValue(bool newValue) {
    isFavorite = newValue;
    notifyListeners();
  }

  Future<void> toggleFavoriteStatus(String token, String userId) async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final url =
        'https://event-a2014.firebaseio.com/userfavourites/$userId/$id.json?auth=$token';
    try {
      final response = await http.put(
        url,
        body: json.encode(
          isFavorite,
        ),
      );
      notifyListeners();
      if (response.statusCode >= 400) {
        _setFavValue(oldStatus);
      }
    } catch (error) {
      _setFavValue(oldStatus);
    }
  }
}
