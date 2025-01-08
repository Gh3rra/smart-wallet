// ignore_for_file: use_build_context_synchronously


import 'package:flutter/material.dart';
import 'package:mobile/screens/transactions/components/step_widget.dart';


class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text("Nuova Transazione",style: TextStyle(fontWeight: FontWeight.w500),),
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
        toolbarHeight: 100,
      ),
      body: const StepWidget(),
    );
  }
}
