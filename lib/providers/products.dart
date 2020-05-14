import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_storage/firebase_storage.dart';
import '../models/http_exception.dart';
import './product.dart';

class Events with ChangeNotifier {
  String imageurl;
  String barcodeUrl;
  List<Event> _items = [];

  final String authToken;
  final String userId;

  Events(this.authToken, this.userId, this._items);

  List<Event> get items {
    return [..._items];
  }

  List<Event> get favoriteItems {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  Event findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> fetchAndSetEvents([bool filterByUser = false]) async {
    final filterString =
        filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    var url =
        'https://Event-a2014.firebaseio.com/Events.json?auth=$authToken&$filterString';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      url =
          'https://Event-a2014.firebaseio.com/userfavourites/$userId.json?auth=$authToken';
      final favoriteResponse = await http.get(url);
      final favoriteData = json.decode(favoriteResponse.body);
      final List<Event> loadedEvents = [];
      extractedData.forEach((prodId, prodData) {
        loadedEvents.add(Event(
            id: prodId,
            title: prodData['title'],
            description: prodData['description'],
            datetime: prodData['datetime'],
            isFavorite:
                favoriteData == null ? false : favoriteData[prodId] ?? false,
            imageUrl: prodData['imageUrl'],
            barcodeurl: prodData['barcodeurl']));
      });
      _items = loadedEvents;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addEvent(Event even) async {
    final url =
        'https://Event-a2014.firebaseio.com/WatingEvents.json?auth=$authToken';
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': even.title,
          'description': even.description,
          'imageUrl': even.imageUrl,
          'datetime': even.datetime,
          'barcodeurl': even.barcodeurl,
          'creatorId': userId,
        }),
      );
      final newEvent = Event(
        title: even.title,
        description: even.description,
        datetime: even.datetime,
        imageUrl: even.imageUrl,
        barcodeurl: even.barcodeurl,
        id: json.decode(response.body)['name'],
      );
      _items.add(newEvent);
      // _items.insert(0, newEvent); // at the start of the list
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateEvent(String id, Event newEvent) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url =
          'https://Event-a2014.firebaseio.com/WatingEvents/$id.json?auth=$authToken';
      await http.patch(url,
          body: json.encode({
            'title': newEvent.title,
            'description': newEvent.description,
            'imageUrl': newEvent.imageUrl,
            'start': newEvent.datetime,
            'barcodeurl': newEvent.barcodeurl,
          }));
      _items[prodIndex] = newEvent;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> deleteEvent(String id) async {
    final url =
        'https://Event-a2014.firebaseio.com/Events/$id.json?auth=$authToken';
    final existingEventIndex = _items.indexWhere((prod) => prod.id == id);
    var existingEvent = _items[existingEventIndex];
    _items.removeAt(existingEventIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingEventIndex, existingEvent);
      notifyListeners();
      throw HttpException('Could not delete Event.');
    }
    existingEvent = null;
  }

  Future<void> uploadimage(
      File image, File baecode, Event _editedEvent, String id) async {
    var now = DateTime.now().toString();
    var fullImageName = 'images/${now}' + '.jpg';
    var fullbarcodeeName = 'images/${now}'+'123456' + '.jpg';
    StorageReference ref = FirebaseStorage.instance.ref().child(fullImageName);
    StorageReference refbarcode = FirebaseStorage.instance.ref().child(fullbarcodeeName);
    StorageUploadTask uploadimage = await ref.putFile(image);
    StorageUploadTask uploadbarcode = await refbarcode.putFile(baecode);
    StorageTaskSnapshot snapshot = await uploadimage.onComplete;
    StorageTaskSnapshot snapshotbarcod = await uploadbarcode.onComplete;
    var url = await snapshot.ref.getDownloadURL();
    var barcodeurl = await snapshotbarcod.ref.getDownloadURL();
    imageurl = url;
    barcodeUrl = barcodeurl;

    _editedEvent = Event(
        title: _editedEvent.title,
        datetime: _editedEvent.datetime,
        description: _editedEvent.description,
        imageUrl: imageurl,
        barcodeurl: barcodeUrl,
        id: _editedEvent.id);
    if (id == null) {
      addEvent(_editedEvent);
      // ignore: unnecessary_statements
    } else {
      updateEvent(id, _editedEvent);
    }
  }
}
