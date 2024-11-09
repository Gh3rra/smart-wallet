// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile/screens/transactions/components/scrollable_title.dart';
import 'package:mobile/screens/transactions/components/step_widget.dart';
import 'package:mobile/services/auth.dart';
import 'package:mobile/services/db.dart';
import 'package:mobile/utils/utils.dart';
import 'package:mobile/widgets/colors.dart';
import 'package:mobile/widgets/my_button.dart';
import 'package:mobile/widgets/my_text_field.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final ScrollController _scrollController = ScrollController();

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
