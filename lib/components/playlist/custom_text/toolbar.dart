// import 'package:flex_color_picker/flex_color_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:zpevnik/components/highlightable.dart';
// import 'package:zpevnik/components/playlist/custom_text/utils/controller.dart';
// import 'package:zpevnik/constants.dart';

// class CustomTextToolbar extends StatelessWidget {
//   final CustomTextController controller;

//   const CustomTextToolbar({super.key, required this.controller});

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     return ListenableBuilder(
//       listenable: controller,
//       builder: (_, __) => Container(
//         color: theme.colorScheme.surface,
//         padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
//         child: SingleChildScrollView(
//           scrollDirection: Axis.horizontal,
//           child: Row(children: [
//             ToolbarButton(
//               icon: Icons.square,
//               color: controller.color,
//               onTap: () => _pickColor(context),
//             ),
//             ToolbarButton(
//               icon: Icons.format_bold,
//               isActive: controller.isBoldActive,
//               onTap: controller.toggleBold,
//             ),
//             ToolbarButton(
//               icon: Icons.format_italic,
//               isActive: controller.isItalicsActive,
//               onTap: controller.toggleItalics,
//             ),
//             ToolbarButton(
//               icon: Icons.format_underline,
//               isActive: controller.isUnderlineActive,
//               onTap: controller.toggleUnderline,
//             ),
//             ToolbarButton(
//               icon: Icons.format_list_bulleted,
//               onTap: controller.toggleUnorderedList,
//             ),
//             ToolbarButton(
//               icon: Icons.format_list_numbered,
//               onTap: controller.toggleOrderedList,
//             ),
//             ToolbarButton(
//               icon: Icons.format_indent_decrease,
//               onTap: controller.unindent,
//             ),
//             ToolbarButton(
//               icon: Icons.format_indent_increase,
//               onTap: controller.indent,
//             ),
//           ]),
//         ),
//       ),
//     );
//   }

//   void _pickColor(BuildContext context) async {
//     final pickedColor = await showColorPickerDialog(context, red);

//     // this has to be done with delay, otherwise will not take effect
//     Future.delayed(const Duration(milliseconds: 50), () => controller.changeColor(pickedColor));
//   }
// }

// class ToolbarButton extends StatelessWidget {
//   final IconData icon;
//   final bool isActive;
//   final Color? color;
//   final Function() onTap;

//   const ToolbarButton({
//     super.key,
//     required this.icon,
//     this.isActive = false,
//     this.color,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Highlightable(
//       onTap: onTap,
//       icon: Icon(icon, color: isActive ? Theme.of(context).colorScheme.primary : color),
//     );
//   }
// }
