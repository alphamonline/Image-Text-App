import 'package:image_text_app/auth/models/user_profile.dart';

class CurrentUser {
  static final CurrentUser _singleton = new CurrentUser._internal();
  static UserProfile? profile;

  factory CurrentUser() {
    return _singleton;
  }

  CurrentUser._internal() {
    // initialization logic here
  }

}