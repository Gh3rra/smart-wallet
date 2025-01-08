import 'package:flutter/material.dart';
import 'package:mobile/common/services/db.dart';
import 'package:mobile/common/utils/colors.dart';

import 'package:mobile/common/widgets/my_button.dart';
import 'package:mobile/common/widgets/my_text_field.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChangeEmailScreen extends StatefulWidget {
  const ChangeEmailScreen({super.key});

  @override
  State<ChangeEmailScreen> createState() => _ChangeEmailScreenState();
}

class _ChangeEmailScreenState extends State<ChangeEmailScreen> {
  final TextEditingController _codeController = TextEditingController();

 /*  submit() async {
    Supabase.instance.client.auth.verifyOTP(type:OtpType.email,email:  );
  } */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(
            margin: const EdgeInsets.only(
              left: 20,
            ),
            child: IconButton(
                style: const ButtonStyle(
                    shape: WidgetStatePropertyAll(CircleBorder())),
                onPressed: () => {Navigator.pop(context)},
                icon: Text(
                  String.fromCharCode(Icons.arrow_back_rounded.codePoint),
                  style: TextStyle(
                      fontFamily: Icons.arrow_back_rounded.fontFamily,
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      color: Theme.of(context).colorScheme.onSurface),
                ))),
        centerTitle: true,
        title: Text(
          "Cambia Email",
          textAlign: TextAlign.start,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 25,
            fontWeight: FontWeight.w500,
          ),
        ),
        toolbarHeight: 100,
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
              const SizedBox(
                height: 20,
              ),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: Text(
                  "Inserisci il codice che ti abbiamo inviato per email per confermare la tua identità",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              const SizedBox(
                height: 50,
              ),

              //FORM
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Form(
                  child: Column(
                    children: [
                      const MyTextField(
                        label: "Codice",
                        obscureText: true,
                        suffixIcon: Icons.password_rounded,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      MyButton(
                        shadowColor: blueShadowColor,
                        onPressed: () {
                          Navigator.push(
                              context,
                              PageRouteBuilder(
                                transitionsBuilder: (context, animation,
                                    secondaryAnimation, child) {
                                  const begin = Offset(1, 0);
                                  const end = Offset.zero;
                                  const curve = Curves.ease;
                                  final tween = Tween(begin: begin, end: end)
                                      .chain(CurveTween(curve: curve));
                                  return SlideTransition(
                                    position: animation.drive(tween),
                                    child: child,
                                  );
                                },
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        const SaveEmailScreen(),
                              ));
                        },
                        radius: 15,
                        height: 60,
                        text: "Continua",
                        backgroundColor:
                            Theme.of(context).colorScheme.onPrimary,
                        color: Theme.of(context).colorScheme.primary,
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

class SaveEmailScreen extends StatefulWidget {
  const SaveEmailScreen({super.key});

  @override
  State<SaveEmailScreen> createState() => __SaveEmailScreenStateState();
}

class __SaveEmailScreenStateState extends State<SaveEmailScreen> {

  final TextEditingController _emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(
            margin: const EdgeInsets.only(
              left: 20,
            ),
            child: IconButton(
                style: const ButtonStyle(
                    shape: WidgetStatePropertyAll(CircleBorder())),
                onPressed: () => {Navigator.pop(context)},
                icon: Text(
                  String.fromCharCode(Icons.arrow_back_rounded.codePoint),
                  style: TextStyle(
                      fontFamily: Icons.arrow_back_rounded.fontFamily,
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      color: Theme.of(context).colorScheme.onSurface),
                ))),
        centerTitle: true,
        title: Text(
          "Cambia Email",
          textAlign: TextAlign.start,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 25,
            fontWeight: FontWeight.w500,
          ),
        ),
        toolbarHeight: 100,
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
              const SizedBox(
                height: 20,
              ),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: Text(
                  "Inserisci la tua nuova mail e la tua password per confermare",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              const SizedBox(
                height: 50,
              ),

              //FORM
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Form(
                  child: Column(
                    children: [
                       MyTextField(
                        controller: _emailController,                        label: "Email",
                        obscureText: false,
                        keyboardType: TextInputType.emailAddress,
                        suffixIcon: Icons.email_outlined,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      MyButton(
                        shadowColor: blueShadowColor,
                        onPressed: ()async {
                          await Db().changeEmail(email: _emailController.text);
                        },
                        radius: 15,
                        height: 60,
                        text: "Salva",
                        backgroundColor:
                            Theme.of(context).colorScheme.onPrimary,
                        color: Theme.of(context).colorScheme.primary,
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
