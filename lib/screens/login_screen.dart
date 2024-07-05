import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/auth_service.dart';

class LoginScreen extends StatelessWidget {
  final AuthService authService = Get.find<AuthService>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                bool loggedIn = await authService.login(
                  emailController.text.trim(),
                  passwordController.text.trim(),
                );
                if (!loggedIn) {
                  Get.snackbar("Error", "Invalid credentials");
                } else {
                  Get.toNamed('/productList');
                }
              },
              child: const Text('Login'),
            ),
            TextButton(
              onPressed: () {
                Get.toNamed('/registration');
              },
              child: const Text('Create an Account'),
            ),
          ],
        ),
      ),
    );
  }
}
