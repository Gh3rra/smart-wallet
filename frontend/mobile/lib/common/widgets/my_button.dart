import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  const MyButton(
      {super.key,
      required this.text,
      required this.backgroundColor,
      this.prefixIcon,
      required this.height,
      required this.radius,
      this.onPressed,
      this.fontSize,
      this.fontWeight,
      this.shadowColor,
      this.color,
      this.isLoading = false,
      this.padding});
  final String text;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color backgroundColor;
  final Widget? prefixIcon;
  final double height;
  final double radius;
  final Function()? onPressed;
  final Color? shadowColor;
  final Color? color;
  final bool isLoading;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              color: shadowColor ?? Colors.transparent,
              blurRadius: 10,
              offset: const Offset(0, 3),
              spreadRadius: -5)
        ],
      ),
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          padding: WidgetStatePropertyAll(padding),
          shape: WidgetStatePropertyAll(RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(radius)))),
          backgroundColor: WidgetStatePropertyAll(backgroundColor),
        ),
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: color,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (prefixIcon != null)
                    Row(
                      children: [
                        prefixIcon!,
                        const SizedBox(
                          width: 15,
                        )
                      ],
                    ),
                  Text(
                    text,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: color,
                        fontSize: fontSize ?? 17,
                        fontWeight: fontWeight ?? FontWeight.w500),
                  )
                ],
              ),
      ),
    );
  }
}
