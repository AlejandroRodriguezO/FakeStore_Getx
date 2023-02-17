import 'package:get/get_state_manager/get_state_manager.dart';

class ThemeController extends GetxController {
  bool _dark = false;

  bool get dark => _dark;

  void changeTheme() {
    _dark = !_dark;
    update();
  }
}
