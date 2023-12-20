// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform, Directory, FileSystemEntity;
import 'dart:developer';
import 'package:window_manager/window_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logging/logging.dart';
import 'package:cupertino_icons/cupertino_icons.dart';

import 'package:dcc_launcher/core/pdf_file_provider.dart';
import 'package:dcc_launcher/ui/list_view.dart';
import 'package:dcc_launcher/ui/pdf_view/pdf_item.dart';
import 'package:dcc_launcher/ui/tab_button.dart';

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
  List<String> _pdfList = [];
  void _handleTabSelection(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final logger = Logger('DccLauncherApp');

  @override
  void initState() {
    super.initState();

    // Set logging level
    Logger.root.level = Level.FINE;
    Logger.root.onRecord.listen((record) {
      log('${record.level.name}: ${record.time}: ${record.message}');
    });

    // Get list of PDF files
    getPdfList((String str) {
      setState(() {
        _pdfList = [..._pdfList, str];
      });
    });

    // Add window listener
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

  Widget _setTabContent() {
    switch (_selectedIndex) {
      case 0:
        return CustomListView(_pdfList, itemBuilder: PdfItem.new);
      case 1:
        return const Text('Content 22');
      default:
        return const Text('Hello world');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Row(
          children: <Widget>[
            Column(
              // mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 2),
                tabButton(
                    iconName: 'docs-icon',
                    index: 0,
                    onTabSelected: _handleTabSelection,
                    isSelected: _selectedIndex == 0),
                tabButton(
                    iconName: 'apps-icon',
                    index: 1,
                    onTabSelected: _handleTabSelection,
                    isSelected: _selectedIndex == 1),
              ],
            ),
            Container(
              width: 4,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Color.fromARGB(255, 146, 152, 198),
                    Color.fromARGB(85, 146, 152, 198),
                    Colors.transparent, // End color is transparent
                  ],
                  stops: [0.0, 0.5, 1],
                ),
              ),
              height: double.infinity,
            ),
            Expanded(
              child: Container(
                alignment: Alignment.topLeft, // Center the content
                child: _setTabContent(),
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
