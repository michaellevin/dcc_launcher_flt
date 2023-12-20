import 'dart:io';

void getPdfList(Function(String) callable) async {
  final dir = Directory('assets/docs');
  final List<FileSystemEntity> entities = await dir.list().toList();
  for (var element in entities) {
    if (element.path.endsWith('.pdf')) {
      callable(element.path);
    }
  }
}
