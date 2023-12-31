import 'dart:io';
import 'package:flutter/material.dart';

// import 'package:pdfx/pdfx.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import 'package:dcc_launcher/ui/list_item.dart';
import 'package:dcc_launcher/core/pdf_file_provider.dart';

class PdfItem extends ListItem {
  final String pdfPath;

  // Private constructor for use with the factory.
  PdfItem._(this.pdfPath, String title, Key? key)
      : super(title, fileType: SupportedFileExtensions.pdf, key: key) {
    print('asset path is $pdfPath');
  }

  // Factory constructor to create a PdfItem.
  factory PdfItem(String path, {Key? key}) {
    path = path.replaceAll('\\', '/');
    String title = path.split('/').last;
    return PdfItem._(path, title, key);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onSecondaryTapUp: (details) {
        if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
          showMenu(
            context: context,
            position: RelativeRect.fromLTRB(
              details.globalPosition.dx,
              details.globalPosition.dy,
              details.globalPosition.dx,
              details.globalPosition.dy,
            ),
            items: [
              const PopupMenuItem(
                value: 'open_external',
                child: Text('Open with external application'),
              ),
            ],
          ).then((selectedValue) {
            if (selectedValue == 'open_external') {
              print("Opening external PDF reader..");
              openPdfWithExternalApplication(pdfPath);
            }
          });
        }
      },
      child: super.build(context), // This will call build method of ListItem
    );
  }

  @override
  void onItemTap(BuildContext context) {
    print('subclass: $pdfPath');
    // final PdfController controller = PdfController(
    //   // document: PdfDocument.openAsset(pdfPath),
    //   document: PdfDocument.openFile("assets/docs/Feldbach_1.pdf"),
    // );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
              width: double.maxFinite,
              height: MediaQuery.of(context).size.height *
                  0.8, // 80% of screen height
              // child: PdfView(controller: controller)
              child: Scaffold(
                body: SfPdfViewer.asset(pdfPath),
              )),
        );
      },
    );
  }
}
