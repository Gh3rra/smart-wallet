import 'package:flutter/material.dart';
import 'package:mobile/screens/transactions/components/scrollable_title.dart';
import 'package:mobile/widgets/my_text_field.dart';

class Prova extends StatefulWidget {
  const Prova({super.key});

  @override
  State<Prova> createState() => _ProvaState();
}

class _ProvaState extends State<Prova> {
  int currentStep = 0;
  FocusNode focusAmount = FocusNode();

  bool isActiva(int i) {
    switch (currentStep) {
      case 0:
        if (i == 0) {
          return true;
        }
        return false;
      case 1:
        if (i == 1) {
          return true;
        }
        return false;

      default:
        return false;
    }
  }

  function() {
    print("CANEEEEEE");
    return false;
  }

  ScrollController scroll = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(controller: scroll, slivers: [
        ScrollableTitle(scrollController: scroll, text: "CIAO"),
        SliverList(
          delegate: SliverChildListDelegate([
            Stepper(
              currentStep: currentStep,
              steps: [
                const Step(title: Text("GIORGIO"), content: Text("data")),
                Step(
                  isActive: isActiva(1),
                  title: const Text("GIORGIO"),
                  content: MyTextField(
                    focusNode: focusAmount,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w400),
                    prefix: Container(
                      padding: const EdgeInsets.only(left: 15),
                      child: const Text(
                        "€ ",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(),
                  ),
                ),
                 Step(
                    title: const Text("GIORGIO"),
                    content: const Text("data"),
                    isActive: function()),
                const Step(title: Text("GIORGIO"), content: Text("data")),
                const Step(title: Text("GIORGIO"), content: Text("data")),
                const Step(title: Text("GIORGIO"), content: Text("data")),
                const Step(title: Text("GIORGIO"), content: Text("data")),
              ],
              onStepContinue: () {
                setState(() {
                  currentStep++;
                });
                Future.delayed(const Duration(milliseconds: 200),() {focusAmount.requestFocus();});
              },
              onStepCancel: () {
                setState(() {
                  focusAmount.requestFocus();
                });
              },
              onStepTapped: (value) {
                setState(() {
                  currentStep = value;
                });
              },
              controller: ScrollController(),
            ),
          ]),
        )
      ]),
    );
  }
}
