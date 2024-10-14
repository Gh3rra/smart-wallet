import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  const MyTextField(
      {super.key,
      this.suffixIcon,
      this.label,
      this.keyboardType,
      this.obscureText,
      this.prefix,
      this.isDense,
      this.contentPadding,
      this.style,
      this.controller,
      this.validator,
      this.stateKey,
      this.readOnly = false, this.onTap});
  final Key? stateKey;
  final IconData? suffixIcon;
  final Widget? prefix;
  final String? label;
  final TextInputType? keyboardType;
  final bool? obscureText;
  final bool? isDense;
  final EdgeInsetsGeometry? contentPadding;
  final TextStyle? style;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool? readOnly;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: stateKey,
      cursorErrorColor: Theme.of(context).colorScheme.onSurface,
      controller: controller,
      style: style,
      onTap: onTap,      obscureText: obscureText != null ? obscureText! : false,
      keyboardType: keyboardType,
      cursorColor: Theme.of(context).colorScheme.onSurface,
      readOnly: readOnly!,
      decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none),
          constraints: const BoxConstraints(minWidth: 150),
          isDense: isDense,
          hintText: label,
          hintStyle: TextStyle(
              fontWeight: FontWeight.w400,
              color: Theme.of(context).colorScheme.onSurface),
          border: const OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(15))),
          contentPadding: contentPadding ?? const EdgeInsets.all(20),
          filled: true,
          fillColor: Theme.of(context).colorScheme.tertiary,
          prefixIcon: prefix,
          prefixIconConstraints:
              const BoxConstraints(minHeight: 0, minWidth: 0),
          suffixIcon: suffixIcon != null
              ? Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: Icon(
                    suffixIcon,
                    color: Theme.of(context).colorScheme.onSurface,
                    size: 30,
                  ),
                )
              : null),
      validator: validator,
    );
  }
}
