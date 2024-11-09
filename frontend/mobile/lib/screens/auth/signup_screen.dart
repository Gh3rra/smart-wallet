// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mobile/screens/auth/login_screen.dart';
import 'package:mobile/screens/auth/signup_password_screen.dart';
import 'package:mobile/screens/auth/signup_personal_data_screen.dart';
import 'package:mobile/screens/main/main_screen.dart';
import 'package:mobile/widgets/my_button.dart';
import 'package:mobile/widgets/my_text_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isLoadingSignUp = false;
  bool isLoadingGoogle = false;
  bool isError = false;
  bool isExist = false;

  bool validateEmail() {
    String email = _emailController.text;
    if (email.isEmpty ||
        !RegExp(r'^[\w-.]+@([\w-]+.)+[\w-]{2,4}$').hasMatch(email)) {
      return false;
    }
    return true;
  }

  signUp() async {
    setState(() {
      isLoadingSignUp = true;
    });
    if (validateEmail()) {
      QuerySnapshot<Map<String, dynamic>> user = await FirebaseFirestore
          .instance
          .collection("users")
          .where("email", isEqualTo: _emailController.text)
          .get();
      if (user.docs.isNotEmpty) {
        setState(() {
          isError = false;
          isExist = true;
        });
      } else {
        setState(() {
          isExist = false;
          isError = false;
          isLoadingSignUp = false;
        });
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SignUpPersonalDataScreen(
                email: _emailController.text,
              ),
            ));
      }
    } else {
      setState(() {
        isError = true;
        isExist = false;
      });
    }

    setState(() {
      isLoadingSignUp = false;
    });
  }

  signUpGoogle() async {
    setState(() {
      isLoadingGoogle = true;
    });
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth!.accessToken, idToken: googleAuth.idToken);

      QuerySnapshot<Map<String, dynamic>> user = await FirebaseFirestore
          .instance
          .collection("users")
          .where("email", isEqualTo: googleUser!.email)
          .get();
      if (user.docs.isNotEmpty) {
        setState(() {
          isError = false;
        });
        await FirebaseAuth.instance.signInWithCredential(credential);
        setState(() {
          isLoadingGoogle = false;
        });
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const MainScreen()),
          (route) => false,
        );
      } else {
        setState(() {
          isError = false;
          isLoadingGoogle = false;
        });
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SignUpPersonalDataScreen(
                  isGoogleSignIn: true,
                  email: googleUser.email,
                  credential: credential),
            ));
      }

      setState(() {
        isError = false;
        isLoadingGoogle = false;
      });
    } catch (e) {
      setState(() {
        isLoadingGoogle = false;
      });
      print(e);
    }
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
                        controller: _emailController,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface),
                        label: "Email",
                        keyboardType: TextInputType.emailAddress,
                        suffixIcon: Icons.mail_outline_rounded,
                      ),
                      isExist
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
                                    "Email già registrata",
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
                                    "Email non valida",
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
                      MyButton(
                        isLoading: isLoadingSignUp,
                        onPressed: isLoadingSignUp == false ? signUp : null,
                        radius: 15,
                        height: 60,
                        text: "Registrati",
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
                        isLoading: isLoadingGoogle,
                        onPressed:
                            isLoadingGoogle == false ? signUpGoogle : null,
                        radius: 15,
                        height: 60,
                        prefixIcon: SvgPicture.asset(
                          "assets/images/google_logo.svg",
                          height: 40,
                        ),
                        text: "Registrati con Google",
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
                            text: "Hai già un account? ",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: Theme.of(context).colorScheme.onSurface),
                          ),
                          TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                if (!isLoadingSignUp && !isLoadingGoogle) {
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginScreen()),
                                      (route) => false);
                                }
                              },
                            text: "Accedi ora",
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
