import 'package:flutter/material.dart';
import 'package:mobile/prova.dart';
import 'package:mobile/screens/auth/login_screen.dart';
import 'package:mobile/screens/home/home_screen.dart';
import 'package:mobile/screens/main/main_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          );
        }
        if (snapshot.hasData && snapshot.data!.session != null) {
          return const MainScreen();
        } 
        if (snapshot.hasError) {
          return const Center(
            child: Text("ERROR"),
          );
        }
        return const LoginScreen();
      },
    );
  }
}
