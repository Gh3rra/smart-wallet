import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
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
          "Cambia Password",
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
                  "Ti abbiamo inviato un link all’email gerri.schiavo@gmail.com",
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
              )
          
              ,
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
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              startTimer();
                            },
                          text: "Invia ora",
                          style:  TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: Theme.of(context).colorScheme.onPrimary),
                        )
                      : TextSpan(
                          text: "Nuovo invio tra $seconds",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
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
