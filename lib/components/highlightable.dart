import 'package:flutter/material.dart';
import 'package:zpevnik/constants.dart';

class HighlightableForegroundColor extends MaterialStateProperty<Color?> {
  final Color? foregroundColor;
  final Color? disabledColor;

  HighlightableForegroundColor({this.foregroundColor, this.disabledColor});

  @override
  Color? resolve(Set<MaterialState> states) {
    if (states.contains(MaterialState.pressed)) return foregroundColor?.withAlpha(0x80);
    if (states.contains(MaterialState.disabled)) return disabledColor;

    return foregroundColor;
  }
}

class HighlightableIconButton extends StatelessWidget {
  final EdgeInsets? padding;
  final Function()? onTap;
  final Widget icon;
  final bool shrinkWrap;

  const HighlightableIconButton({super.key, this.padding, this.onTap, required this.icon, this.shrinkWrap = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return IconButton(
      constraints: shrinkWrap ? const BoxConstraints() : null,
      style: IconButton.styleFrom(
        padding: padding,
        highlightColor: Colors.transparent,
        tapTargetSize: shrinkWrap ? MaterialTapTargetSize.shrinkWrap : null,
      ).copyWith(
        foregroundColor: HighlightableForegroundColor(
          foregroundColor: theme.iconTheme.color,
          disabledColor: theme.disabledColor,
        ),
      ),
      onPressed: onTap,
      icon: icon,
    );
  }
}

class HighlightableTextButton extends StatelessWidget {
  final EdgeInsets padding;
  final Color? foregroundColor;
  final TextStyle? textStyle;
  final Function()? onTap;
  final Widget child;
  final Widget? icon;

  const HighlightableTextButton({
    super.key,
    this.padding = EdgeInsets.zero,
    this.foregroundColor,
    this.textStyle,
    this.onTap,
    required this.child,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final textStyle = this.textStyle ?? theme.textTheme.bodyMedium;

    final style = TextButton.styleFrom(
      padding: padding,
      textStyle: textStyle,
      minimumSize: const Size(0, 0),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    ).copyWith(
      foregroundColor: HighlightableForegroundColor(
        foregroundColor: foregroundColor ?? textStyle?.color,
        disabledColor: theme.disabledColor,
      ),
      overlayColor: const MaterialStatePropertyAll(Colors.transparent),
    );

    if (icon != null) {
      return TextButton.icon(
        style: style,
        onPressed: onTap,
        icon: icon!,
        label: child,
      );
    }

    return TextButton(style: style, onPressed: onTap, child: child);
  }
}
