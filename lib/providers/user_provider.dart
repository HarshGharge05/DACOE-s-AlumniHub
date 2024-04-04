import 'package:flutter/widgets.dart';
import 'package:alumniapp/models/user.dart';
import 'package:alumniapp/resources/auth_methods.dart';

class UserProvider with ChangeNotifier {
  Users? _user;
  final AuthMethods _authMethods = AuthMethods();

  Users get getUser => _user!;

  Future<void> refreshUser() async {
    Users user = await _authMethods.getUserDetails();
    _user = user;
    notifyListeners();
  }
}
