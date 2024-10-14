import 'package:flutter/material.dart';
import 'package:mobile/screens/auth/signup_password_screen.dart';
import 'package:mobile/screens/home/home_page.dart';
import 'package:mobile/widgets/my_button.dart';
import 'package:mobile/widgets/my_text_field.dart';

class SignUpPersonalDataScreen extends StatefulWidget {
  const SignUpPersonalDataScreen({super.key, required this.email});
  final String email;

  @override
  State<SignUpPersonalDataScreen> createState() =>
      _SignUpPersonalDataScreenState();
}

class _SignUpPersonalDataScreenState extends State<SignUpPersonalDataScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  bool isLoading = false;
  bool isNameError = false;
  bool isSurnameError = false;

  validateName() {
    if (_nameController.text.isEmpty) {
      setState(() {
        isNameError = true;
      });
      return false;
    }
    setState(() {
      isNameError = false;
    });
    return true;
  }

  validateSurname() {
    if (_surnameController.text.isEmpty) {
      setState(() {
        isSurnameError = true;
      });
      return false;
    }
    setState(() {
      isSurnameError = false;
    });
    return true;
  }

  submit() {
    setState(() {
      isLoading = true;
    });
    bool nameValidator = validateName();
    bool surnameValidator = validateSurname();
    if (nameValidator && surnameValidator) {
      setState(() {
        isNameError = false;
        isSurnameError = false;
        isLoading = false;
      });
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => SignUpPasswordScreen(
                    email: widget.email,
                    name: _nameController.text,
                    surname: _surnameController.text,
                  )),
          (route) => false);
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
              //LOGO

              Container(
                padding: const EdgeInsets.only(left: 30),
                alignment: Alignment.centerLeft,
                child: Text(
                  "Dati Personali",
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
                        controller: _nameController,
                        label: "Nome",
                      ),
                      isNameError
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
                                    "Inserisci un nome",
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
                        controller: _surnameController,
                        label: "Cognome",
                      ),
                      isSurnameError
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
                                    "Inserisci un cognome",
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
