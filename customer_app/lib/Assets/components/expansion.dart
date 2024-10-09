import 'package:flutter/material.dart';

/// CustomExpansionTile Widget
///
/// This widget is a reusable ExpansionTile with a title, an icon, and a child widget.
///
/// **Usage:**
///
/// 1. Import the `CustomExpansionTile` widget into your file:
///
/// ```dart
/// import 'package:your_app/assets/components/expansion_tile_component.dart';
/// ```
///
/// 2. Call the `CustomExpansionTile` widget by passing in the required parameters:
///
/// ```dart
/// CustomExpansionTile(
///   title: 'My Title',
///   icon: Icons.info,
///   child: YourChildWidget(), // Pass any widget that will be displayed inside the expansion area
/// )
/// ```
///
/// - `title`: A string that will be displayed as the title of the expansion tile.
/// - `icon`: An `IconData` object that will be shown next to the title.
/// - `child`: The widget that will be shown when the expansion tile is expanded.
///
/// **Example:**
///
/// ```dart
/// CustomExpansionTile(
///   title: 'Settings',
///   icon: Icons.settings,
///   child: Column(
///     children: [
///       Text('Option 1'),
///       Text('Option 2'),
///     ],
///   ),
/// )
/// ```
import 'package:flutter/material.dart';

class CustomExpansionTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  // Constructor using positional parameters
  const CustomExpansionTile(this.title, this.icon, this.child, {super.key});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Row(
        children: [
          Icon(
            icon,
            color: Colors.white, // Set the icon color to white
          ),
          const SizedBox(width: 10),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white, // Set the text color to white
            ),
          ),
        ],
      ),
      children: [child, const SizedBox(height: 30)],
    );
  }
}
