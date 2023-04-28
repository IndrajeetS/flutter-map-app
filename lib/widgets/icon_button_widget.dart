import 'package:flutter/material.dart';

class IconButtonWidget extends StatelessWidget {
  final IconData? icon;
  final void Function()? onPressed;
  final String? tooltip;

  const IconButtonWidget({
    super.key,
    this.icon,
    this.onPressed,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      child: IconButton(
        icon: Icon(icon),
        onPressed: onPressed,
        tooltip: tooltip,
      ),
    );
  }
}
