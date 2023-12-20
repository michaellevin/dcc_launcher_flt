import 'package:flutter/material.dart';

Widget tabButton(
    {required String iconName,
    required int index,
    required Function(int) onTabSelected,
    required bool isSelected}) {
  return SizedBox(
    width: 36,
    height: 36,
    child: ElevatedButton(
      onPressed: () {
        onTabSelected(index);
      },
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero, // Remove padding
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0), // Square shape
        ),
        backgroundColor: Colors.transparent, // Normal state color
        disabledForegroundColor: Colors.red, // Color when button is disabled
        foregroundColor: Colors.white, // Color when button is pressed
        shadowColor: Colors.transparent, // No shadow
      ).copyWith(
        backgroundColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.pressed)) {
              return const Color.fromARGB(
                  255, 147, 128, 159); // Color when button is pressed
            }
            // if (index == _selectedIndex) {
            if (isSelected) {
              return const Color.fromARGB(
                  255, 146, 152, 198); // Color for the selected button
            }
            return null; // Use the default value
          },
        ),
      ),
      child: Image.asset(
          'assets/icons/$iconName.png'), // Use the correct asset path
    ),
  );
}
