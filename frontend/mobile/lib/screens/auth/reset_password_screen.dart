import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key, required this.email});
  final String email;

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  bool isRunning = true;
  int seconds = 30;
  Timer? timer;

  void startTimer() {
    setState(() {
      isRunning = true;
    });
    timer = Timer.periodic(const Duration(seconds: 1), (time) {
      setState(() {
        seconds--;
      });
      if (seconds == 0) {
        timer!.cancel();
        seconds = 30;
        setState(() {
          isRunning = false;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  submit() {
    if (!isRunning) {
      startTimer();
      FirebaseAuth.instance.sendPasswordResetEmail(email: widget.email);
    }
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
                  fontFamily: Icons.arrow_back_rounded.fontFamily,
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  color: Theme.of(context).colorScheme.onSurface),
            )),
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      resizeToAvoidBottomInset: true,
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
                alignment: Alignment.center,
                child: Text(
                  "Cambia Password",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: Text(
                  "Abbiamo inviato un’email con un link per reimpostare la password all’indirizzo di posta elettronica associato al tuo account.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(
                height: 70,
              ),
              Image.asset(
                "assets/images/mailbox.gif",
                height: 300,
              ),
              const SizedBox(
                height: 70,
              ),
              Text.rich(
                TextSpan(children: [
                  TextSpan(
                    text: "Non hai ricevuto l'email? ",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.onSurface),
                  ),
                  !isRunning
                      ? TextSpan(
                          recognizer: TapGestureRecognizer()..onTap = submit,
                          text: "Invia ora",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: Theme.of(context).colorScheme.onPrimary),
                        )
                      : TextSpan(
                          text: "Nuovo invio tra $seconds",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: Colors.grey[700]),
                        ),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
