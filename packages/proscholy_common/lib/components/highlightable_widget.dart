import 'package:flutter/material.dart';

class HighlightableForegroundColor extends WidgetStateProperty<Color?> {
  final Color? foregroundColor;
  final Color? disabledColor;

  HighlightableForegroundColor({this.foregroundColor, this.disabledColor});

  @override
  Color? resolve(Set<WidgetState> states) {
    if (states.contains(WidgetState.pressed)) return foregroundColor?.withAlpha(0x80);
    if (states.contains(WidgetState.disabled)) return disabledColor;

    return foregroundColor;
  }
}

class HighlightableWidget extends StatelessWidget {
  final Color? foregroundColor;
  final Color? highlightColor;
  final EdgeInsets? padding;
  final AlignmentGeometry? alignment;
  final TextStyle? textStyle;
  final BorderRadius? borderRadius;

  final bool shrinkWrap;
  final bool highlightBackground;

  final bool isEnabled;
  final Function()? onTap;

  final Widget? icon;
  final Widget? child;

  const HighlightableWidget({
    super.key,
    this.foregroundColor,
    this.highlightColor,
    this.padding,
    this.alignment,
    this.textStyle,
    this.borderRadius,
    this.shrinkWrap = false,
    this.highlightBackground = false,
    this.isEnabled = true,
    this.onTap,
    this.icon,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (highlightBackground) {
      return InkWell(
        borderRadius: borderRadius,
        highlightColor: highlightColor,
        onTap: isEnabled ? onTap : null,
        child: Padding(padding: padding ?? EdgeInsets.zero, child: child),
      );
    }

    if (icon != null && child == null) {
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
        onPressed: isEnabled ? onTap : null,
        icon: icon!,
      );
    }

    final textStyle = this.textStyle ?? theme.textTheme.bodyMedium;

    final style = TextButton.styleFrom(
      padding: padding,
      textStyle: textStyle,
      minimumSize: const Size(0, 0),
      alignment: alignment,
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      // set animation duration to zero, so the text and icon colors are synced
      animationDuration: const Duration(),
    ).copyWith(
      foregroundColor: HighlightableForegroundColor(
        foregroundColor: foregroundColor ?? textStyle?.color,
        disabledColor: theme.disabledColor,
      ),
      overlayColor: const WidgetStatePropertyAll(Colors.transparent),
    );

    if (icon != null) {
      return TextButton.icon(style: style, onPressed: isEnabled ? onTap : null, icon: icon!, label: child!);
    }

    return TextButton(style: style, onPressed: isEnabled ? onTap : null, child: child!);
  }
}
