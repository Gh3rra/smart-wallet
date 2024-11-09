import 'package:flutter/material.dart';
import 'package:mobile/widgets/colors.dart';

class SettingWidget extends StatefulWidget {
  /// Rapprensenta la riga di un'impostazione. Contiene:
  /// + title: il nome dell'impostazione
  /// + prefixIcon: icona che rappresenta l'impostazione
  ///
  /// Può contentenere:
  /// + subTitle: un ulteriore descrizionedell'impostazione
  /// + isSwitch: true se l'impostazione è uno switch
  /// + onTap: funzione che si avvia al tocco dell'impostazione
  /// + onChanged: funzione che si avvia al variare dello switch
  const SettingWidget(
      {super.key,
      required this.prefixIcon,
      required this.title,
      this.subTitle,
      required this.prefixIconSize,
      this.onTap,
      this.isSwitch = false,
      this.value,
      this.onChanged});
  final IconData prefixIcon;
  final double prefixIconSize;
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
    return Material(
      color: Theme.of(context).colorScheme.secondary,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: widget.onTap,
        child: Container(
          height: 70,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: widget.isSwitch == true
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                      Flexible(
                        child: Row(
                          children: [
                            Icon(
                              widget.prefixIcon,
                              size: widget.prefixIconSize,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            widget.subTitle != null
                                ? Flexible(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(widget.title,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 17,
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
                                        fontSize: 17,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface),
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
                    widget.prefixIcon,
                    size: widget.prefixIconSize,
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
                                      fontSize: 17,
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
                              fontSize: 17,
                              color: Theme.of(context).colorScheme.onSurface),
                        ),
                ]),
        ),
      ),
    );
  }
}
