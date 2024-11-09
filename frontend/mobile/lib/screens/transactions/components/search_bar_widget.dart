import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SearchBarWidget extends StatefulWidget {
  const SearchBarWidget({super.key});

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextFormField(
        style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(0),
            hintText: "Cerca",
            fillColor: Theme.of(context).colorScheme.tertiary,
            filled: true,
            hintStyle:
                TextStyle(color: Theme.of(context).colorScheme.onTertiary),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none),
            prefixIcon: Icon(
              Icons.search_rounded,
              color: Theme.of(context).colorScheme.onTertiary,
            )),
      ),
    );
  }
}
