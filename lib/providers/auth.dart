import 'dart:convert';
import 'dart:core';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/http_exception.dart';

final usersRef = Firestore.instance.collection('users');

class Auth extends ChangeNotifier {
  String _token;

  String _userId;
  String username;
  var uuid = Uuid();

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_token != null) {
      return _token;
    }
    return null;
  }

  String get userId {
    return _userId;
  }

  Future<void> _athuntication(
      String email, String password, String _urlSegmet) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$_urlSegmet?key=AIzaSyBpuBhpn4Xnv7CMqGPR-BkpywAtDDPOJbQ';
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );

      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];


      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode(
        {
          'token': _token,
          'userId': _userId,
        },
      );

      prefs.setString('userData', userData);
    } catch (error) {
      throw error;
    }
  }

  Future<void> getUser({String userid}) async {
    final QuerySnapshot snapshot =
        await usersRef.where('userid', isEqualTo: userid).getDocuments();
    snapshot.documents.forEach((DocumentSnapshot doc) {
      username = doc.data['username'];
    });
  }

  Future<void> singIn({String email, String password}) async {
    await _athuntication(email, password, 'signInWithPassword');
    if(_userId!=null){
      await getUser(userid: _userId);
    }
  }

  Future<void> createUser(
      {String username,
      String email,
      String userid,
      }) async {
    await usersRef.document(uuid.v1()).setData({
      'id': uuid.v1(),
      "username": username,
      "email": email,
      "userid": userid,
    });
  }

  Future<void> singUp({
    String username,
    String email,
    String password,
  }) async {

    await _athuntication(email, password, 'signUp');
   if(_userId!=null){
     await createUser(
       username: username,
       email: email,
       userid: _userId,
     );
     await getUser(userid: _userId);
   }
  }
  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData =
    json.decode(prefs.getString('userData')) as Map<String, Object>;
    final token = extractedUserData['token'];

    if (token==null) {
      return false;
    }
    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    if(extractedUserData['userId']!=null){
      await getUser(userid: _userId);
    }
    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;

    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

}
