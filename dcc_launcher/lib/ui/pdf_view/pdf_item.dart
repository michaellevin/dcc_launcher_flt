import 'package:flutter/material.dart';
import 'package:dcc_launcher/ui/list_item.dart';

class PdfItem extends ListItem {
  late final String pdfPath;

  // Private constructor for use with the factory.
  PdfItem._(String title, Key? key)
      : super(title, fileType: SupportedFileExtensions.pdf, key: key) {
    pdfPath = title;
  }

  // Factory constructor to create a PdfItem.
  factory PdfItem(String path, {Key? key}) {
    String title = path.replaceAll("\\", "/").split('/').last;
    return PdfItem._(title, key);
  }

  @override
  void onItemTap(BuildContext context) {
    print('subclass: $pdfPath');
  }
}
