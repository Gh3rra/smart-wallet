/* import 'package:flutter/material.dart';
import 'package:mobile/common/services/db.dart';
import 'package:mobile/common/utils/utils.dart';
import 'package:mobile/model/transaction_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Prova extends StatefulWidget {
  const Prova({
    super.key,
  });

  @override
  State<Prova> createState() => _ProvaState();
}

class _ProvaState extends State<Prova> {
  final user = Supabase.instance.client.auth.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: ElevatedButton(
              onPressed: () async {
               final r = await Supabase.instance.client.auth.;
               print(r);
              },style: const ButtonStyle(backgroundColor:WidgetStatePropertyAll(Colors.grey) ),
              child: Text(user != null ? user!.email! : "Boh",style: const TextStyle(color: Colors.red),),),
        ));
  }
}
 */