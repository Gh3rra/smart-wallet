// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile/screens/auth/signup_personal_data_screen.dart';
import 'package:mobile/screens/home/home_page.dart';
import 'package:mobile/services/db.dart';
import 'package:mobile/widgets/my_button.dart';
import 'package:mobile/widgets/my_text_field.dart';

class SignUpPasswordScreen extends StatefulWidget {
  const SignUpPasswordScreen(
      {super.key,
      required this.email,
      required this.name,
      required this.surname});
  final String email;
  final String name;
  final String surname;

  @override
  State<SignUpPasswordScreen> createState() => _SignUpPasswordScreenState();
}

class _SignUpPasswordScreenState extends State<SignUpPasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool isErrorPassword = false;
  bool isErrorConfirmPassword = false;
  bool isLoading = false;

  validatePassword() {
    String password = _passwordController.text;
    if (password.isEmpty || !RegExp(r'^[\s\S]{8,}$').hasMatch(password)) {
      return false;
    }
    return true;
  }

  validateConfirmPassword() {
    String confirmPassword = _confirmPasswordController.text;
    if (confirmPassword.isEmpty ||
        confirmPassword != _passwordController.text) {
      return false;
    }
    return true;
  }

  submit() async {
    setState(() {
      isLoading = true;
    });
    if (validatePassword()) {
      if (validateConfirmPassword()) {
        try {
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
              email: widget.email, password: _passwordController.text);
          await Db().createUser(
              email: widget.email, name: widget.name, surname: widget.surname);
          setState(() {
            isErrorConfirmPassword = false;
            isErrorPassword = false;
            isLoading = false;
          });
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const HomePage(),
              ));
        } catch (e) {
          print(e);
        }
      } else {
        setState(() {
          isErrorPassword = false;
          isErrorConfirmPassword = true;
          isLoading = false;
        });
      }
    } else {
      setState(() {
        isErrorPassword = true;
        isErrorConfirmPassword = false;
      });
      if (!validateConfirmPassword()) {
        setState(() {
          isErrorConfirmPassword = true;
        });
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        leading: IconButton(
            padding: const EdgeInsets.only(left: 20),
            onPressed: () => Navigator.pop(context),
            icon: Text(
              String.fromCharCode(Icons.arrow_back_rounded.codePoint),
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontFamily: Icons.arrow_back_rounded.fontFamily,
                  fontSize: 30,
                  fontWeight: FontWeight.w800),
            )),
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: Container(
        alignment: Alignment.topCenter,
        width: double.maxFinite,
        height: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //LOGO

              Container(
                padding: const EdgeInsets.only(left: 30),
                alignment: Alignment.centerLeft,
                child: Text(
                  "Registrazione",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(
                height: 100,
              ),

              //FORM
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Form(
                  child: Column(
                    children: [
                      MyTextField(
                        controller: _passwordController,
                        label: "Password",
                        obscureText: true,
                        suffixIcon: Icons.lock_outline,
                      ),
                      isErrorPassword
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: const Text(
                                    "Password non valida",
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ],
                            )
                          : const SizedBox(),
                      const SizedBox(
                        height: 20,
                      ),
                      MyTextField(
                        label: "Conferma password",
                        controller: _confirmPasswordController,
                        obscureText: true,
                        suffixIcon: Icons.lock_outline,
                      ),
                      isErrorConfirmPassword
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: const Text(
                                    "Le due password non coincidono",
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ],
                            )
                          : const SizedBox(),
                      const SizedBox(
                        height: 50,
                      ),
                      MyButton(
                        isLoading: isLoading,
                        onPressed: isLoading == false ? submit : null,
                        radius: 15,
                        height: 60,
                        text: "Continua",
                        backgroundColor:
                            Theme.of(context).colorScheme.onPrimary,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
