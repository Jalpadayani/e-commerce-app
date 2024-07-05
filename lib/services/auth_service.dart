import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _userDetailsKey = 'userDetails';
  static const String _isLoggedInKey = 'isLoggedIn';
  static const String _favoritesKey = 'favorites';

  Future<Map<String, dynamic>> _getUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString(_userDetailsKey);
    if (jsonString != null) {
      return Map<String, dynamic>.from(json.decode(jsonString));
    }
    return {};
  }

  Future<void> _setUserDetails(Map<String, dynamic> userDetails) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonString = json.encode(userDetails);
    await prefs.setString(_userDetailsKey, jsonString);
  }

  Future<bool> register(
      String email, String password, String name, String profilePicture) async {
    Map<String, dynamic> userDetails = await _getUserDetails();

    if (userDetails.containsKey(email)) {
      Get.snackbar("Email ID already exists", "");
      return false;
    }
    String base64Image = base64Encode(File(profilePicture).readAsBytesSync());

    userDetails[email] = {
      'password': password,
      'name': name,
      'profilePicture': base64Image,
    };
    await _setUserDetails(userDetails);
    await setUserEmail(email); // Set current user's email upon registration

    Get.snackbar("Registration successful", "");
    return true;
  }

  Future<void> setUserEmail(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('currentUserEmail', email);
  }

  Future<bool> login(String email, String password) async {
    Map<String, dynamic> userDetails = await _getUserDetails();
    if (userDetails.containsKey(email) &&
        userDetails[email]['password'] == password) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_isLoggedInKey, true);
      await setUserEmail(email); // Set current user's email upon login
      Get.snackbar("Welcome", "");
      return true;
    } else {
      Get.snackbar("Invalid credentials", "");
      return false;
    }
  }

  Future<void> updateUserProfile(
      String email, String name, String imagePath) async {
    Map<String, dynamic> userDetails = await _getUserDetails();
    Map<String, String> userProfile = await getUserProfile();
    String email = await getUserEmail();
    String? storedImagePath = userProfile['imagePath'];
    String? storedPassword = userProfile['password'];
    String? base64Image;
    if (imagePath.isNotEmpty && imagePath.length < 100) {
      base64Image = base64Encode(File(imagePath).readAsBytesSync());
    }
    userDetails.remove(email);
    userDetails[email] = {
      'password': storedPassword,
      'name': name,
      'profilePicture': base64Image ?? storedImagePath,
    };
    await _setUserDetails(userDetails);
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_isLoggedInKey);
    await prefs.remove('currentUserEmail');
    Get.offAllNamed('/login');
  }

  Future<String> getUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('currentUserEmail') ?? '';
  }

  Future<Map<String, String>> getUserProfile() async {
    Map<String, dynamic> userDetails = await _getUserDetails();
    String email = await getUserEmail();
    if (userDetails.containsKey(email)) {
      String? name = userDetails[email]['name'];
      String? imagePath = userDetails[email]['profilePicture'];
      return {'email': email, 'name': name ?? '', 'imagePath': imagePath ?? ''};
    }
    return {};
  }

  Future<void> updateUserDetails(
      String email, String name, String profilePicture) async {
    Map<String, dynamic> userDetails = await _getUserDetails();
    if (userDetails.containsKey(email)) {
      userDetails[email]['name'] = name;
      userDetails[email]['profilePicture'] = profilePicture;
      await _setUserDetails(userDetails);
      Get.snackbar("Profile updated", "");
    }
  }

  Future<void> toggleFavorite(String productId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList(_favoritesKey) ?? [];
    if (favorites.contains(productId)) {
      favorites.remove(productId);
    } else {
      favorites.add(productId);
    }
    await prefs.setStringList(_favoritesKey, favorites);
  }

  Future<List<String>> getFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_favoritesKey) ?? [];
  }
}
