import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:window_manager/window_manager.dart';
// import 'package:window_size/window_size.dart' as window_size;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    // setWindowTitle('Dcc Launcher');
    // min_width = 600;
    // min_height = 800;
    // // setWindowMaxSize(const Size(max_width, max_height));
    // setWindowMinSize(const Size(min_width, min_height));
    WidgetsFlutterBinding.ensureInitialized();
    await windowManager.ensureInitialized();
    if (Platform.isWindows) {
      WindowManager.instance.setMinimumSize(const Size(400, 600));
      WindowManager.instance.setMaximumSize(const Size(600, 800));
    }
  }

  runApp(const DccLauncherApp());
}

// void setInitialWindowSize() {
//   window_size.getWindowInfo().then((window) {
//     if (window.screen != null) {
//       final screenFrame = window.screen!.visibleFrame;
//       final width = 600.0;
//       final height = 800.0;
//       final left = ((screenFrame.width - width) / 2).roundToDouble();
//       final top = ((screenFrame.height - height) / 3).roundToDouble();
//       final frame = Rect.fromLTWH(left, top, width, height);
//       window_size.setWindowFrame(frame);
//     }
//   });
// }

class DccLauncherApp extends StatefulWidget {
  const DccLauncherApp({Key? key})
      : super(key: key); // Including the Key parameter

  @override
  DccLauncherAppState createState() => DccLauncherAppState();
}

class DccLauncherAppState extends State<DccLauncherApp> {
  int _selectedIndex = 0;

  Widget _buildIconButton(String iconName, int index) {
    return SizedBox(
      width: 36,
      height: 36,
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            _selectedIndex = index;
          });
        },
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero, // Remove padding
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0), // Square shape
          ),
        ),
        child: Image.asset(
            'assets/icons/$iconName.png'), // Use the correct asset path
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Row(
          children: <Widget>[
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                _buildIconButton('docs-icon', 0),
                _buildIconButton('apps-icon', 1),
              ],
            ),
            Expanded(
              child: Container(
                alignment: Alignment.center, // Center the content
                child: _selectedIndex == 0
                    ? const Text('Content 1')
                    : const Text('Content 2'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
