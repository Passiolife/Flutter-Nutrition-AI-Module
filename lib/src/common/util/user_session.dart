import '../models/sign_in/sign_in_response.dart';
import '../models/user_profile/user_profile_model.dart';

class UserSession {
  /// Here, implementing the code for singleton class.
  static final UserSession _instance = UserSession._privateConstructor();

  UserSession._privateConstructor();

  static UserSession get instance => _instance;

  /// Here, actual code.
  ///

  SignInResponse? signInResponse;
  UserProfileModel? userProfile;
}
