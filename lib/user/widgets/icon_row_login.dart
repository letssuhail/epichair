// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';

// class IconRow extends StatefulWidget {
//   @override
//   _IconRowState createState() => _IconRowState();
// }

// class _IconRowState extends State<IconRow> {
//   int _selectedIndex = 0;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         // ToggleButtons for selecting options
//         ToggleButtons(
//           isSelected:
//               List.generate(_icons.length, (index) => _selectedIndex == index),
//           onPressed: (index) {
//             setState(() {
//               _selectedIndex = index;
//             });
//           },
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: SvgPicture.asset('assets/icons/client.svg',
//                   width: 100, height: 100),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: SvgPicture.asset('assets/icons/staff.svg',
//                   width: 100, height: 100),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }
