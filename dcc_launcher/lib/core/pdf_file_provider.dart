import 'dart:io';
import 'package:url_launcher/url_launcher.dart';

void getPdfList(Function(String) callable) async {
  final dir = Directory('assets/docs');
  final List<FileSystemEntity> entities = await dir.list().toList();
  for (var element in entities) {
    if (element.path.endsWith('.pdf')) {
      callable(element.path);
    }
  }
}

Future<void> openPdfWithExternalApplication(String relativePath) async {
  // Construct the full path based on where your application runs.
  // This path construction will vary based on your application's deployment and file structure.
  String fullPath = '${Directory.current.path}/$relativePath';

  if (Platform.isWindows) {
    fullPath = fullPath.replaceAll('/', '\\');
  }
  print(fullPath);
  final file = File(fullPath);

  if (await file.exists()) {
    final uri = Uri.file(file.path);

    if (!await launchUrl(uri)) {
      print('Could not launch $uri');
    }
  } else {
    print('File does not exist at path: $fullPath');
  }
}
