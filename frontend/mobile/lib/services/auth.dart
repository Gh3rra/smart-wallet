import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  String userId = FirebaseAuth.instance.currentUser!.uid;
}
