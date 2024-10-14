import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mobile/services/auth.dart';
import 'package:mobile/widgets/add_category_widget.dart';
import 'package:mobile/widgets/category_widget.dart';
import 'package:mobile/widgets/colors.dart';
import 'package:mobile/widgets/my_button.dart';

class IncomeCategoryScreen extends StatefulWidget {
  const IncomeCategoryScreen({super.key});

  @override
  State<IncomeCategoryScreen> createState() => _IncomeCategoryScreenState();
}

class _IncomeCategoryScreenState extends State<IncomeCategoryScreen> {
  String userId = AuthService().userId;
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
          "Entrate",
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: MyButton(
                  onPressed: () async {
                  await  showDialog(
                      context: context,
                      builder: (context) => const AddCategoryWidget(
                        type: "ENTRATA",
                      ),
                    );
                  },
                  shadowColor: blueShadowColor,
                  text: "Aggiungi categoria",
                  backgroundColor: Theme.of(context).colorScheme.onPrimary,
                  height: 50,
                  radius: 20,
                  prefixIcon: Icon(
                    Icons.add_rounded,
                    size: 30,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("users")
                      .doc(userId)
                      .collection("incomesCategory")
                      .orderBy("name")
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.onSurface,
                      );
                    }
                    if (snapshot.hasData) {
                      List<QueryDocumentSnapshot<Map<String, dynamic>>>
                          categoryList = snapshot.data!.docs;
                      return Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          boxShadow: [
                            BoxShadow(
                                color: Theme.of(context).colorScheme.shadow,
                                blurRadius: 30,
                                spreadRadius: -8),
                          ],
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: categoryList.length,
                            itemBuilder: (context, index) {
                              var element = categoryList[index];
                              return CategoryWidget(
                                  id: element.id,
                                  type: "ENTRATA",
                                  name: element["name"],
                                  icon: IconData(element["icon"],
                                      fontFamily: "MaterialIcons"));
                            }),
                      );
                    }

                    return const Text("Errore nel caricamento");
                  })
            ],
          ),
        ),
      ),
    );
  }
}
