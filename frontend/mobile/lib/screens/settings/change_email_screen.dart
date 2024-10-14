import 'package:flutter/material.dart';

import 'package:mobile/widgets/colors.dart';
import 'package:mobile/widgets/my_button.dart';
import 'package:mobile/widgets/my_text_field.dart';

class ChangeEmailScreen extends StatefulWidget {
  const ChangeEmailScreen({super.key});

  @override
  State<ChangeEmailScreen> createState() => _ChangeEmailScreenState();
}

class _ChangeEmailScreenState extends State<ChangeEmailScreen> {
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
                      fontWeight: FontWeight.w800,color: Theme.of(context).colorScheme.onSurface),
                ))),
        centerTitle: true,
        title:  Text(
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
                child:  Text(
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
                      const MyTextField(
                        label: "Email",
                        obscureText: false,
                        keyboardType: TextInputType.emailAddress,
                        suffixIcon: Icons.email_outlined,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      const MyTextField(
                        label: "Password",
                        obscureText: true,
                        suffixIcon: Icons.password_rounded,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      MyButton(
                        shadowColor: blueShadowColor,
                        onPressed: () {
                          //ALERT "EMAIL SALVATA"
                        },
                        radius: 15,
                        height: 60,
                        text: "Salva",
                        backgroundColor: Theme.of(context).colorScheme.onPrimary,color: Theme.of(context).colorScheme.secondary,
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
