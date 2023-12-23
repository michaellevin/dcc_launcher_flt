import 'package:flutter/material.dart';
import 'package:yaml/yaml.dart';
import 'dart:io';

Future<String?> launchApplication(String appPath, List appEnv) async {
  try {
    if (await File(appPath).exists()) {
      await Process.start(appPath, []);
      return null; // Indicates success
    } else {
      return 'Application path does not exist: $appPath';
    }
  } catch (e) {
    return 'Failed to launch the application: $e';
  }
}

String getExecutablePath(app) {
  /// Returns the executable path for the given app depends on platform
  String executable = "";
  switch (Platform.operatingSystem) {
    case 'linux':
      executable = app['linux_executable'] ?? "";
      break;
    case 'macos':
      executable = app['macos_executable'] ?? "";
      break;
    case 'windows':
      executable = app['windows_executable'] ?? "";
      break;
  }
  return executable;
}

List<List<T>> chunkList<T>(List<T> list, int chunkSize) {
  var chunks = <List<T>>[];
  for (var i = 0; i < list.length; i += chunkSize) {
    var end = (i + chunkSize < list.length) ? i + chunkSize : list.length;
    chunks.add(list.sublist(i, end));
  }
  return chunks;
}

class AppLauncherWidget extends StatelessWidget {
  /// The config file loaded as a YamlMap
  final YamlMap? config;

  const AppLauncherWidget({super.key, required this.config});

  @override
  Widget build(BuildContext context) {
    if (config == null) {
      // Config is not loaded yet, show a loading indicator
      return const CircularProgressIndicator();
    }

    // Using null-aware operators to safely access config properties
    // final Map<dynamic, dynamic> global_environment = config!['global_environment'] as Map<dynamic, dynamic>? ?? {};
    final List<dynamic> applications =
        config!['applications'] as List<dynamic>? ?? [];
    final List<dynamic> applicationRows =
        chunkList(applications, 3); // Split applications into chunks of 3
    final List<dynamic> utilities =
        config!['utilities'] as List<dynamic>? ?? [];

    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text('Applications',
              style: TextStyle(fontWeight: FontWeight.bold)),
          ...applicationRows.map((chunk) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: chunk.map<Widget>((app) {
                print(getExecutablePath(app));
                return _buildIconButton(
                  context,
                  iconPath: app['icon'],
                  label: '${app['name']} ${app['version']}',
                  appPath: getExecutablePath(app),
                  appEnv: app['environment'],
                );
              }).toList(),
            );
          }),
          const Divider(),
          const Text('Utilities',
              style: TextStyle(fontWeight: FontWeight.bold)),
          ...utilities.map((app) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _buildIconButton(context,
                    iconPath: app['icon'],
                    label: '${app['name']} ${app['version']}',
                    appPath: getExecutablePath(app)),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildIconButton(BuildContext context,
      {required String iconPath,
      required String label,
      required String appPath,
      List? appEnv}) {
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
            onPressed: () async {
              String? errorMessage =
                  await launchApplication(appPath, appEnv ?? []);
              if (errorMessage != null) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('No application found'),
                      content: Text(errorMessage),
                      actions: <Widget>[
                        TextButton(
                          child: Text('OK'),
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                          },
                        ),
                      ],
                    );
                  },
                );
              }
            },
          ),
          Text(label),
        ],
      ),
    );
  }
}
