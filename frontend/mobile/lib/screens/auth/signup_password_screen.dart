// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:mobile/common/services/db.dart';
import 'package:mobile/common/widgets/my_button.dart';
import 'package:mobile/common/widgets/my_text_field.dart';
import 'package:mobile/screens/main/main_screen.dart';

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
  bool containsNumber = false;
  bool containsUpperChar = false;
  bool containsLowerChar = false;
  bool passwordLength = false;

  validatePassword() {
    if (containsNumber && containsLowerChar && containsUpperChar) {
      return true;
    }
    return false;
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
          await Db().signUpWithEmailAndPassword(
              name: widget.name,
              surname: widget.surname,
              email: widget.email,
              password: _passwordController.text);

          setState(() {
            isErrorConfirmPassword = false;
            isErrorPassword = false;
            isLoading = false;
          });
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const MainScreen(),
            ),
            (route) => false,
          );
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

  checkingPassword() {
    if (_passwordController.text.length >= 8) {
      passwordLength = true;
    }else{
      passwordLength = false;
    }
    if (_passwordController.text.contains(RegExp(r'[A-Z]'))) {
      containsUpperChar = true;
    } else {
      containsUpperChar = false;
    }
    if (_passwordController.text.contains(RegExp(r'[a-z]'))) {
      containsLowerChar = true;
    } else {
      containsLowerChar = false;
    }
    if (_passwordController.text.contains(RegExp(r'[\d]'))) {
      containsNumber = true;
    } else {
      containsNumber = false;
    }
    setState(
      () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    _passwordController.addListener(checkingPassword);
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
                    
                           Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(children: [
                                Row(
                                  children: [
                                    !passwordLength
                                        ? !isErrorPassword
                                            ? Container(
                                                padding:
                                                    const EdgeInsets.all(5),
                                                width: 20,
                                                height: 20,
                                                child: Container(
                                                  width: 10,
                                                  height: 10,
                                                  decoration: BoxDecoration(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onTertiary,
                                                      shape: BoxShape.circle),
                                                ),
                                              )
                                            : const SizedBox(
                                                width: 20,
                                                height: 20,
                                                child: Icon(
                                                  Icons.close,
                                                  color: Colors.red,
                                                ),
                                              )
                                        : const SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: Icon(
                                              Icons.done,
                                              color: Colors.greenAccent,
                                            ),
                                          ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "Almeno 8 caratteri",
                                      style: TextStyle(
                                          color: !passwordLength
                                              ? !isErrorPassword
                                                  ? Theme.of(context)
                                                      .colorScheme
                                                      .onTertiaryFixed
                                                  : Colors.red
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .onSurface),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    !containsLowerChar
                                        ? !isErrorPassword
                                            ? Container(
                                                padding:
                                                    const EdgeInsets.all(5),
                                                width: 20,
                                                height: 20,
                                                child: Container(
                                                  width: 10,
                                                  height: 10,
                                                  decoration: BoxDecoration(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onTertiary,
                                                      shape: BoxShape.circle),
                                                ),
                                              )
                                            : const SizedBox(
                                                width: 20,
                                                height: 20,
                                                child: Icon(
                                                  Icons.close,
                                                  color: Colors.red,
                                                ),
                                              )
                                        : const SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: Icon(
                                              Icons.done,
                                              color: Colors.greenAccent,
                                            ),
                                          ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "Una lettera minuscola",
                                      style: TextStyle(
                                          color: !containsLowerChar
                                              ? !isErrorPassword
                                                  ? Theme.of(context)
                                                      .colorScheme
                                                      .onTertiaryFixed
                                                  : Colors.red
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .onSurface),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    !containsUpperChar
                                        ? !isErrorPassword
                                            ? Container(
                                                padding:
                                                    const EdgeInsets.all(5),
                                                width: 20,
                                                height: 20,
                                                child: Container(
                                                  width: 10,
                                                  height: 10,
                                                  decoration: BoxDecoration(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onTertiary,
                                                      shape: BoxShape.circle),
                                                ),
                                              )
                                            : const SizedBox(
                                                width: 20,
                                                height: 20,
                                                child: Icon(
                                                  Icons.close,
                                                  color: Colors.red,
                                                ),
                                              )
                                        : const SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: Icon(
                                              Icons.done,
                                              color: Colors.greenAccent,
                                            ),
                                          ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "Una lettera maiuscola",
                                      style: TextStyle(
                                          color: !containsUpperChar
                                              ? !isErrorPassword
                                                  ? Theme.of(context)
                                                      .colorScheme
                                                      .onTertiaryFixed
                                                  : Colors.red
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .onSurface),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    !containsNumber
                                        ? !isErrorPassword
                                            ? Container(
                                                padding:
                                                    const EdgeInsets.all(5),
                                                width: 20,
                                                height: 20,
                                                child: Container(
                                                  width: 10,
                                                  height: 10,
                                                  decoration: BoxDecoration(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onTertiary,
                                                      shape: BoxShape.circle),
                                                ),
                                              )
                                            : const SizedBox(
                                                width: 20,
                                                height: 20,
                                                child: Icon(
                                                  Icons.close,
                                                  color: Colors.red,
                                                ),
                                              )
                                        : const SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: Icon(
                                              Icons.done,
                                              color: Colors.greenAccent,
                                            ),
                                          ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "Una cifra",
                                      style: TextStyle(
                                          color: !containsNumber
                                              ? !isErrorPassword
                                                  ? Theme.of(context)
                                                      .colorScheme
                                                      .onTertiaryFixed
                                                  : Colors.red
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .onSurface),
                                    ),
                                  ],
                                ),
                              ]),
                            )
                        ,
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
