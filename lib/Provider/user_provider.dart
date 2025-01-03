import 'package:flutter/foundation.dart';
import 'package:funroullete_new/api/auth-service-.dart';


import '../Model/user-login-model.dart';

class UserProvider with ChangeNotifier {
  UserModel? _user;

  final AuthService _authService;

  UserProvider(this._authService);

  UserModel? get user => _user;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  setLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  Future<UserModel?> login(context, String username, String password) async {
    setLoading(true);
    UserModel? result = await _authService.login(context, username, password);

    if (result != null) {
      _user = result;
      notifyListeners();
      setLoading(false);
    } else {
      if (kDebugMode) {
        print("login failed in user provider");
      }
      setLoading(false);
    }
    return null;
  }
}
