import 'package:flutter/material.dart';

class AppLauncherWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Applications', style: TextStyle(fontWeight: FontWeight.bold)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _buildIconButton('assets/icons/maya.png', 'Maya 2024'),
              _buildIconButton('assets/icons/houdini.png', 'Houdini 19.5'),
              _buildIconButton('assets/icons/blender.png', 'Blender 4.0.2'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _buildIconButton(
                  'assets/icons/after_effects.png', 'After Effects 2023'),
              _buildIconButton('assets/icons/nuke.png', 'Nuke'),
            ],
          ),
          Divider(),
          Text('Utilities', style: TextStyle(fontWeight: FontWeight.bold)),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              _buildIconButton('assets/icons/djv.png', 'DJV 2.0.8'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton(String iconPath, String label) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          IconButton(
            icon: SizedBox(
              width: 48, // Set your desired width
              height: 48, // Set your desired height
              child: Image.asset(iconPath, fit: BoxFit.contain),
            ),
            // iconSize: 24,
            onPressed: () {
              // Handle button press
              print('Button pressed: $label');
            },
          ),
          Text(label),
        ],
      ),
    );
  }
}
