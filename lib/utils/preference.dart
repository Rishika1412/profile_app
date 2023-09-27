import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static final UserPreferences _instance = UserPreferences._internal();

  factory UserPreferences() {
    return _instance;
  }

  UserPreferences._internal();

  late SharedPreferences _prefs;

  initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  String get username {
    return _prefs.getString('username') ?? '';
  }

  set username(String value) {
    _prefs.setString('username', value);
  }

  String get password {
    return _prefs.getString('password') ?? '';
  }

  set password(String value) {
    _prefs.setString('password', value);
  }

  bool get authFlag {
    return _prefs.getBool('authFlag') ?? false;
  }

  set authFlag(bool value) {
    _prefs.setBool('authFlag', value);
  }

  String get name {
    return _prefs.getString('name') ?? '';
  }

  set name(String value) {
    _prefs.setString('name', value);
  }

  String get email {
    return _prefs.getString('email') ?? '';
  }

  set email(String value) {
    _prefs.setString('email', value);
  }

  String get phoneno {
    return _prefs.getString('phoneno') ?? '';
  }

  set phoneno(String value) {
    _prefs.setString('phoneno', value);
  }

  String get image {
    return _prefs.getString('image') ?? '';
  }

  set image(String value) {
    _prefs.setString('image', value);
  }

  String get pincode {
    return _prefs.getString('pincode') ?? '';
  }

  set pincode(String value) {
    _prefs.setString('pincode', value);
  }

  String get state {
    return _prefs.getString('state') ?? '';
  }

  set state(String value) {
    _prefs.setString('state', value);
  }

  String get district {
    return _prefs.getString('district') ?? '';
  }

  set district(String value) {
    _prefs.setString('district', value);
  }

  String get country {
    return _prefs.getString('country') ?? '';
  }

  set country(String value) {
    _prefs.setString('country', value);
  }
}

Future saveImage(Uint8List imageBytes) async {
  final prefs = UserPreferences();
  String base64Image = base64Encode(imageBytes);
  prefs.image = base64Image;
}

Uint8List getImage() {
  final prefs = UserPreferences();
  Uint8List bytes = base64Decode(prefs.image);
  return bytes;
}

clearprefs() {
  final prefs = UserPreferences();
  prefs.authFlag = false;
  // prefs.username = '';
  // prefs.password = '';
  // prefs.name = '';
  prefs.email = '';

  prefs.phoneno = '';
  prefs.image = '';
  prefs.pincode = '';
  prefs.state = '';
  prefs.district = '';
  prefs.country = '';
}
