import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'dart:developer';
import 'package:window_manager/window_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logging/logging.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    windowManager.setTitle('DCC Launcher v0.2.0');
    windowManager.setIcon('assets/icons/launcher_icon.png');
    windowManager.setMinimumSize(const Size(400, 600));

    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Restore size and position
    Size size = Size(
      prefs.getDouble('windowWidth') ?? 400,
      prefs.getDouble('windowHeight') ?? 600,
    );
    Offset position = Offset(
      prefs.getDouble('windowX') ?? -1,
      prefs.getDouble('windowY') ?? -1,
    );
    log('saved size: $size.toString()');
    log('saved position: $position.toString()');

    if (position.dx != -1 && position.dy != -1) {
      windowManager.setPosition(position);
    }
    windowManager.setSize(size);

    // WindowOptions windowOptions = const WindowOptions(
    //   // size: Size(400, 600),
    //   // center: true,
    //   backgroundColor: Colors.transparent,
    // );
    // windowManager.waitUntilReadyToShow(windowOptions, () async {
    //   await windowManager.show();
    //   await windowManager.focus();
    // });
  }

  runApp(const DccLauncherApp());
}

class DccLauncherApp extends StatefulWidget {
  const DccLauncherApp({Key? key})
      : super(key: key); // Including the Key parameter

  @override
  DccLauncherAppState createState() => DccLauncherAppState();
}

class DccLauncherAppState extends State<DccLauncherApp> with WindowListener {
  int _selectedIndex = 0;
  final logger = Logger('DccLauncherApp');

  @override
  void initState() {
    super.initState();

    Logger.root.level = Level.FINE;
    Logger.root.onRecord.listen((record) {
      log('${record.level.name}: ${record.time}: ${record.message}');
    });

    windowManager.addListener(this);
    _init();
  }

  void _init() async {
    // Add this line to override the default close handler
    await windowManager.setPreventClose(true);
    setState(() {});
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

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

  @override
  void onWindowEvent(String eventName) {
    log('[WindowManager] onWindowEvent: $eventName');
  }

  @override
  void onWindowClose() async {
    final windowSize = await windowManager.getSize();
    final windowPosition = await windowManager.getPosition();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('windowWidth', windowSize.width);
    await prefs.setDouble('windowHeight', windowSize.height);
    await prefs.setDouble('windowX', windowPosition.dx);
    await prefs.setDouble('windowY', windowPosition.dy);
    logger.fine('Closing window..');
    logger.fine('Saved window size: $windowSize');
    logger.fine('Saved window position: $windowPosition');
    await windowManager.destroy();
  }
}
