import 'package:get/get.dart';

import 'services/auth_service.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthService()); // Example: Initialize AuthService globally
  }
}
