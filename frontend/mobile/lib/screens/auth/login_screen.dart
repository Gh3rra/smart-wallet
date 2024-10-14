// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mobile/screens/auth/forgot_password_screen.dart';
import 'package:mobile/screens/auth/signup_screen.dart';
import 'package:mobile/screens/home/home_page.dart';
import 'package:mobile/widgets/my_button.dart';
import 'package:mobile/widgets/my_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  bool isLoadingLogIn = false;
  bool isLoadingGoogle = false;
  bool isError = false;

  bool validateEmail() {
    String email = _emailController.text;
    if (email.isEmpty ||
        !RegExp(r'^[\w-.]+@([\w-]+.)+[\w-]{2,4}$').hasMatch(email)) {
      return false;
    }
    return true;
  }

  bool validatePassword() {
    String password = _passwordController.text;
    if (password.isEmpty || !RegExp(r'^[\s\S]{8,}$').hasMatch(password)) {
      return false;
    }
    return true;
  }

  logIn() async {
    setState(() {
      isLoadingLogIn = true;
    });
    if (validateEmail() && validatePassword()) {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: _emailController.text, password: _passwordController.text);
        setState(() {
          isError = false;
          isLoadingLogIn = false;
        });
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ),
          (route) => false,
        );
      } catch (e) {
        setState(() {
          isError = true;
        });
        print(e);
      }
    } else {
      setState(() {
        isError = true;
      });
    }
    setState(() {
      isLoadingLogIn = false;
    });
  }

  logInGoogle() async {
    setState(() {
      isLoadingGoogle = true;
    });
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth!.accessToken, idToken: googleAuth.idToken);
      await FirebaseAuth.instance.signInWithCredential(credential);
      setState(() {
        isError = false;
        isLoadingGoogle = false;
      });
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
        (route) => false,
      );
    } catch (e) {
      setState(() {
        isError = true;
      });
      print(e);
    }
    setState(() {
      isLoadingGoogle = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        alignment: Alignment.center,
        width: double.maxFinite,
        height: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //LOGO
              SvgPicture.asset(
                "assets/images/wallet.svg",
                height: 120,
                colorFilter: ColorFilter.mode(
                    Theme.of(context).colorScheme.onSurface, BlendMode.srcIn),
              ),
              Text(
                "Benvenuto/a su \nSmart Wallet",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 50,
              ),

              //FORM
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      MyTextField(
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface),
                        controller: _emailController,
                        label: "Email",
                        keyboardType: TextInputType.emailAddress,
                        suffixIcon: Icons.mail_outline_rounded,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      MyTextField(
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface),
                        controller: _passwordController,
                        label: "Password",
                        obscureText: true,
                        suffixIcon: Icons.lock_outline,
                      ),
                      isError
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
                                    "Email o password errata",
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
                        height: 15,
                      ),
                      Container(
                          padding: const EdgeInsets.only(right: 15),
                          alignment: Alignment.centerRight,
                          child: Text.rich(
                            TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const ForgotPasswordScreen(),
                                      ));
                                },
                              text: "Hai dimenticato la password?",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color:
                                      Theme.of(context).colorScheme.onSurface),
                            ),
                          )),
                      const SizedBox(
                        height: 15,
                      ),
                      MyButton(
                        onPressed: isLoadingLogIn == false ? logIn : null,
                        isLoading: isLoadingLogIn,
                        radius: 15,
                        height: 60,
                        text: "Accedi",
                        backgroundColor:
                            Theme.of(context).colorScheme.onPrimary,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Text(
                        "Oppure",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).colorScheme.onSurface),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      MyButton(
                        onPressed:
                            isLoadingGoogle == false ? logInGoogle : null,
                        isLoading: isLoadingGoogle,
                        radius: 15,
                        height: 60,
                        prefixIcon: SvgPicture.asset(
                          "assets/images/google_logo.svg",
                          height: 40,
                        ),
                        text: "Accedi con Google",
                        backgroundColor:
                            Theme.of(context).colorScheme.onSurface,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Text.rich(
                        TextSpan(children: [
                          TextSpan(
                            text: "Non hai un account? ",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: Theme.of(context).colorScheme.onSurface),
                          ),
                          TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                if (!isLoadingLogIn && !isLoadingGoogle) {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const SignUpScreen(),
                                      ));
                                }
                              },
                            text: "Registrati ora",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: Theme.of(context).colorScheme.onPrimary),
                          ),
                        ]),
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
