import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../services/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService authService = Get.find<AuthService>();
  TextEditingController nameController = TextEditingController();
  String? imagePath;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Uint8List convertBase64Image(String base64String) {
    return const Base64Decoder().convert(base64String);
  }

  Future<void> _loadProfile() async {
    Map<String, String> userProfile = await authService.getUserProfile();

    String? storedImagePath = userProfile['imagePath'];
    if (storedImagePath != null && storedImagePath.isNotEmpty) {
      setState(() {
        nameController.text = userProfile['name'] ?? '';
        imagePath = userProfile['imagePath'] ?? "";
      });
    }
  }

  Future<void> _updateProfile() async {
    String email = await authService.getUserEmail();
    String name = nameController.text.trim();
    if (name.isEmpty) {
      Get.snackbar('Error', 'Name cannot be empty');
      return;
    } else {
      await authService.updateUserProfile(email, name, imagePath ?? '');
      nameController.clear();
      Get.snackbar('Success', 'Profile updated');
      Get.toNamed('/productList');
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        imagePath = pickedImage.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 50,
            ),
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 80,
                backgroundImage: imagePath != null
                    ? MemoryImage(convertBase64Image(imagePath!))
                    : const NetworkImage(
                            'https://fakestoreapi.com/img/71-3HjGNDUL._AC_SY879._SX._UX._SY._UY_.jpg')
                        as ImageProvider<Object>,
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateProfile,
              child: const Text('Update Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
