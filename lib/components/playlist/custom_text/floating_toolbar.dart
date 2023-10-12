// import 'package:flutter/material.dart';
// import 'package:zpevnik/components/highlightable.dart';
// import 'package:zpevnik/components/playlist/custom_text/utils/controller.dart';
// import 'package:zpevnik/constants.dart';

// class FloatingToolbar extends StatelessWidget {
//   final CustomTextController controller;

//   const FloatingToolbar({
//     super.key,
//     required this.controller,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     return Container(
//       decoration: BoxDecoration(
//         color: theme.colorScheme.surface,
//         borderRadius: BorderRadius.circular(kDefaultRadius),
//         boxShadow: [BoxShadow(color: theme.shadowColor.withAlpha(0x80), spreadRadius: 0.1, blurRadius: 5)],
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(kDefaultRadius),
//         child: Material(
//           child: IntrinsicHeight(
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 if (controller.canCopy) FloatingToolbarButton(text: 'Kopírovat', onTap: controller.copy),
//                 if (controller.canCopy) const VerticalDivider(width: 0),
//                 if (controller.canCut) FloatingToolbarButton(text: 'Vyjmout', onTap: controller.cut),
//                 if (controller.canPaste) FloatingToolbarButton(text: 'Vložit', onTap: controller.paste),
//                 if (controller.canPaste) const VerticalDivider(width: 0),
//                 if (controller.canSelect) FloatingToolbarButton(text: 'Vybrat', onTap: controller.select),
//                 if (controller.canSelect) const VerticalDivider(width: 0),
//                 if (controller.canSelect) FloatingToolbarButton(text: 'Vybrat vše', onTap: controller.selectAll),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class FloatingToolbarButton extends StatelessWidget {
//   final String text;
//   final Function() onTap;

//   const FloatingToolbarButton({super.key, required this.text, required this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     return Highlightable(
//       highlightBackground: true,
//       padding: const EdgeInsets.all(kDefaultPadding),
//       onTap: onTap,
//       child: Text(text),
//     );
//   }
// }
