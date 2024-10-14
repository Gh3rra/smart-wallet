import 'package:flutter/material.dart';
import 'package:mobile/widgets/colors.dart';
import 'package:mobile/widgets/my_button.dart';
import 'package:mobile/widgets/my_text_field.dart';

class ExampleWidget extends StatefulWidget {
  const ExampleWidget({super.key});

  @override
  State<ExampleWidget> createState() => _ExampleWidgetState();
}

class _ExampleWidgetState extends State<ExampleWidget> {
  int step = 0;
  int stepReached = 0;
  double paddingTitle = 20;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.offset < 50) {
        setState(() {
          paddingTitle = 20 + _scrollController.offset;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Step> steps = [
      //TYPE
      Step(
          state: step == 0
              ? StepState.editing
              : step > 0
                  ? StepState.complete
                  : StepState.indexed,
          isActive: step == 0,
          stepStyle: StepStyle(
              color: Theme.of(context).colorScheme.onSurface,
              connectorColor: Colors.blue,
              connectorThickness: 16,
              indexStyle:
                  TextStyle(color: Theme.of(context).colorScheme.secondary)),
          title: const Text("Tipo"),
          content: Container(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MyButton(
                    onPressed: () {
                      setState(() {
                        step++;
                        if (step > stepReached) stepReached = step;
                      });
                    },
                    text: "ENTRATA",
                    fontSize: 15,
                    backgroundColor: Theme.of(context).colorScheme.onPrimary,
                    height: 40,
                    radius: 20,color: Theme.of(context).colorScheme.secondary,), 
                MyButton(
                    onPressed: () {
                      setState(() {
                        step++;
                        if (step > stepReached) stepReached = step;
                      });
                    },
                    text: "USCITA",
                    fontSize: 15,
                    backgroundColor: Theme.of(context).colorScheme.onSecondary,
                    height: 40,
                    radius: 20,color: Theme.of(context).colorScheme.secondary,)
              ],
            ),
          )),
      //AMOUNT
      Step(
          state: step == 1
              ? StepState.editing
              : stepReached > 1
                  ? StepState.complete
                  : StepState.indexed,
          isActive: step == 1,
          stepStyle:  StepStyle(
              color: fourth,
              connectorColor: Colors.blue,
              connectorThickness: 16,
              errorColor: Colors.green,
              indexStyle: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary)),
          title: const Text("Importo"),
          content: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                IntrinsicWidth(
                  child: MyTextField(
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w500),
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
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyButton(
                        onPressed: () {
                          setState(() {
                            step--;
                          });
                        },
                        fontSize: 15,
                        text: "INDIETRO",
                        backgroundColor: fourth,
                        height: 40,
                        radius: 20,color: Theme.of(context).colorScheme.secondary,),
                    MyButton(
                        onPressed: () {
                          setState(() {
                            step++;
                            if (step > stepReached) {
                              stepReached = step;
                            }
                          });
                        },
                        fontSize: 15,
                        text: "CONTINUA",
                        backgroundColor: fourth,
                        height: 40,
                        radius: 20,color: Theme.of(context).colorScheme.secondary,)
                  ],
                ),
              ],
            ),
          )),
      //TITLE
      Step(
          state: step == 2
              ? StepState.editing
              : step > 2
                  ? StepState.complete
                  : StepState.indexed,
          isActive: step == 2,
          stepStyle:  StepStyle(
              color: fourth,
              connectorColor: Colors.blue,
              connectorThickness: 16,
              errorColor: Colors.green,
              indexStyle: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary)),
          title: const Text("Titolo"),
          content: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: MyTextField(
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w500),
                    prefix: Container(
                      padding: const EdgeInsets.only(left: 10),
                      child: const Icon(
                        Icons.title_rounded,
                        size: 27,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyButton(
                        onPressed: () {
                          setState(() {
                            step--;
                          });
                        },
                        fontSize: 15,
                        text: "INDIETRO",
                        backgroundColor: fourth,
                        height: 40,
                        radius: 20,color: Theme.of(context).colorScheme.secondary,),
                    MyButton(
                        onPressed: () {
                          setState(() {
                            step++;
                            if (step > stepReached) {
                              stepReached = step;
                            }
                          });
                        },
                        fontSize: 15,
                        text: "CONTINUA",
                        backgroundColor: fourth,
                        height: 40,
                        radius: 20,color: Theme.of(context).colorScheme.secondary,)
                  ],
                ),
              ],
            ),
          )),
      //DATE
      Step(
          state: step == 3
              ? StepState.editing
              : step > 3
                  ? StepState.complete
                  : StepState.indexed,
          isActive: step == 3,
          stepStyle:  StepStyle(
              color: fourth,
              connectorColor: Colors.blue,
              connectorThickness: 16,
              errorColor: Colors.green,
              indexStyle: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary)),
          title: const Text("Importo"),
          content: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: MyTextField(
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w500),
                    prefix: Container(
                      padding: const EdgeInsets.only(left: 10),
                      child: const Icon(
                        Icons.title_rounded,
                        size: 27,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyButton(
                        onPressed: () {
                          setState(() {
                            step--;
                          });
                        },
                        fontSize: 15,
                        text: "INDIETRO",
                        backgroundColor: fourth,
                        height: 40,
                        radius: 20,color: Theme.of(context).colorScheme.secondary,),
                    MyButton(
                        onPressed: () {
                          setState(() {
                            step++;
                            if (step > stepReached) {
                              stepReached = step;
                            }
                          });
                        },
                        fontSize: 15,
                        text: "CONTINUA",
                        backgroundColor: fourth,
                        height: 40,
                        radius: 20,color: Theme.of(context).colorScheme.secondary,)
                  ],
                ),
              ],
            ),
          )),
      //CATEGORY
      Step(
          state: step == 4
              ? StepState.editing
              : step > 4
                  ? StepState.complete
                  : StepState.indexed,
          isActive: step == 4,
          stepStyle:  StepStyle(
              color: fourth,
              connectorColor: Colors.blue,
              connectorThickness: 16,
              errorColor: Colors.green,
              indexStyle: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary)),
          title: const Text("Importo"),
          content: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: MyTextField(
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w500),
                    prefix: Container(
                      padding: const EdgeInsets.only(left: 10),
                      child: const Icon(
                        Icons.title_rounded,
                        size: 27,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyButton(
                        onPressed: () {
                          setState(() {
                            step--;
                          });
                        },
                        fontSize: 15,
                        text: "INDIETRO",
                        backgroundColor: fourth,
                        height: 40,
                        radius: 20,color: Theme.of(context).colorScheme.secondary,),
                    MyButton(
                        onPressed: () {
                          setState(() {
                            step++;
                            if (step > stepReached) {
                              stepReached = step;
                            }
                          });
                        },
                        fontSize: 15,
                        text: "CONTINUA",
                        backgroundColor: fourth,
                        height: 40,
                        radius: 20,color: Theme.of(context).colorScheme.secondary,)
                  ],
                ),
              ],
            ),
          )),
      //WALLET
      Step(
          state: step == 5
              ? StepState.editing
              : step > 5
                  ? StepState.complete
                  : StepState.indexed,
          isActive: step == 5,
          stepStyle:  StepStyle(
              color: fourth,
              connectorColor: Colors.blue,
              connectorThickness: 16,
              errorColor: Colors.green,
              indexStyle: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary)),
          title: const Text("Importo"),
          content: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: MyTextField(
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w500),
                    prefix: Container(
                      padding: const EdgeInsets.only(left: 10),
                      child: const Icon(
                        Icons.title_rounded,
                        size: 27,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyButton(
                        onPressed: () {
                          setState(() {
                            step--;
                          });
                        },
                        fontSize: 15,
                        text: "INDIETRO",
                        backgroundColor: fourth,
                        height: 40,
                        radius: 20,color: Theme.of(context).colorScheme.secondary,),
                    MyButton(
                        onPressed: () {
                          setState(() {
                            step++;
                            if (step > stepReached) {
                              stepReached = step;
                            }
                          });
                        },
                        fontSize: 15,
                        text: "CONTINUA",
                        backgroundColor: fourth,
                        height: 40,
                        radius: 20,color: Theme.of(context).colorScheme.secondary,)
                  ],
                ),
              ],
            ),
          )),
      //SUMMARY
      Step(
          state: step == 6
              ? StepState.editing
              : step > 6
                  ? StepState.complete
                  : StepState.indexed,
          isActive: step == 6,
          stepStyle: StepStyle(
              color: fourth,
              connectorColor: Colors.blue,
              connectorThickness: 16,
              errorColor: Colors.green,
              indexStyle:
                  TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
          title: const Text("Importo"),
          content: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      Text("sadasda"),
                      Text("sadasda"),
                      Text("sadasda"),
                      Text("sadasda"),
                      Text("sadasda"),
                      Text("sadasda"),
                      Text("sadasda"),
                      Text("sadasda"),
                      Text("sadasda"),
                      Text("sadasda"),
                      Text("sadasda"),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyButton(
                        onPressed: () {
                          setState(() {
                            step--;
                          });
                        },
                        fontSize: 15,
                        text: "INDIETRO",
                        backgroundColor: fourth,
                        height: 40,
                        radius: 20,color: Theme.of(context).colorScheme.secondary,),
                    MyButton(
                        onPressed: () {
                          setState(() {
                            Navigator.pop(context);
                          });
                        },
                        fontSize: 15,
                        text: "INVIA",
                        backgroundColor: fourth,
                        height: 40,
                        radius: 20,color: Theme.of(context).colorScheme.secondary,)
                  ],
                ),
              ],
            ),
          ))
    ];

    return Scaffold(
        body: CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverAppBar(
          scrolledUnderElevation: 0,
          expandedHeight: 120,
          backgroundColor: Theme.of(context).colorScheme.surface,
          snap: false,
          floating: false,
          pinned: true,
          leading: IconButton(
              padding: const EdgeInsets.only(left: 20),
              onPressed: () => Navigator.pop(context),
              icon: Text(
                String.fromCharCode(Icons.arrow_back_rounded.codePoint),
                style: TextStyle(
                    fontFamily: Icons.arrow_back_rounded.fontFamily,
                    fontSize: 30,
                    fontWeight: FontWeight.w800,color: Theme.of(context).colorScheme.onSurface),
              )),
          flexibleSpace: FlexibleSpaceBar(
            collapseMode: CollapseMode.none,
            expandedTitleScale: 1.3,
            centerTitle: true,
            title: Container(
              padding: EdgeInsets.only(left: paddingTitle),
              alignment: Alignment.bottomLeft,
              child: const Text(
                "Nuova Transazione",
                style: TextStyle(
                    color: fourth, fontSize: 20, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ),
        SliverList(
            delegate: SliverChildListDelegate([
          Stepper(
            physics: const NeverScrollableScrollPhysics(),
            connectorColor: const WidgetStatePropertyAll(fourth),
            connectorThickness: 2,
            controlsBuilder: (context, details) {
              return const SizedBox();
            },
            onStepTapped: (value) {
              if (value <= stepReached) {
                setState(() {
                  step = value;
                });
              }
            },
            currentStep: step,
            steps: steps,
          ),
        ]))
      ],
    ));
  }
}
