import 'package:flutter/material.dart';
import 'package:mobile/model/user_model.dart';

class UserProvider with ChangeNotifier {
  UserModel? _user;

  UserModel? get user => _user;

  initialize() {
    
  }
}
