import 'package:flutter/material.dart';
import 'package:mobile/widgets/colors.dart';

class SettingWidget extends StatefulWidget {
  const SettingWidget(
      {super.key,
      required this.icon,
      required this.title,
      this.subTitle,
      required this.iconSize,
      this.onTap,
      this.isSwitch = false,
      this.value,
      this.onChanged});
  final IconData icon;
  final double iconSize;
  final String title;
  final String? subTitle;
  final void Function()? onTap;
  final bool isSwitch;
  final bool? value;
  final void Function(bool)? onChanged;

  @override
  State<SettingWidget> createState() => _SettingWidgetState();
}

class _SettingWidgetState extends State<SettingWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        height: 70,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: widget.isSwitch == true
            ? Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Flexible(
                  child: Row(
                    children: [
                      Icon(
                        widget.icon,
                        size: widget.iconSize,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      widget.subTitle != null
                          ? Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(widget.title,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 20,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface)),
                                  Text(widget.subTitle!,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 13,
                                          color: onTertiary))
                                ],
                              ),
                            )
                          : Text(
                              widget.title,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20,
                                  color: Theme.of(context).colorScheme.onSurface),
                            ),
                    ],
                  ),
                ),
                Switch(
                  trackOutlineColor:
                      const WidgetStatePropertyAll(Colors.transparent),
                  value: widget.value!,
                  onChanged: widget.onChanged,
                  activeColor: Theme.of(context).colorScheme.onPrimary,
                  inactiveTrackColor: const Color(0xff909092),
                  inactiveThumbColor: const Color(0xffD9D9D9),
                )
              ])
            : Row(children: [
                Icon(
                  widget.icon,
                  size: widget.iconSize,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                const SizedBox(
                  width: 20,
                ),
                widget.subTitle != null
                    ? Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(widget.title,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 20,
                                    color:
                                        Theme.of(context).colorScheme.onSurface)),
                            Text(widget.subTitle!,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 13,
                                    color: onTertiary))
                          ],
                        ),
                      )
                    : Text(
                        widget.title,
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                            color: Theme.of(context).colorScheme.onSurface),
                      ),
              ]),
      ),
    );
  }
}
