import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

enum SupportedFileExtensions {
  pdf,
} //, docx, doc, pptx, ppt, xlsx, xls, txt }

abstract class ListItem extends StatelessWidget {
  final String title;
  final SupportedFileExtensions fileType;

  const ListItem(this.title,
      {this.fileType = SupportedFileExtensions.pdf, Key? key})
      : super(key: key);

  Icon _getIcon() {
    switch (fileType) {
      case SupportedFileExtensions.pdf:
        return const Icon(CupertinoIcons.book,
            color: Color.fromARGB(255, 146, 152, 198));
      default:
        return const Icon(CupertinoIcons.book, color: Colors.blue);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () => onItemTap(context),
        leading: _getIcon(),
        title: Text(title),
      ),
    );
  }

  void onItemTap(BuildContext context) {
    print(title);
  }
}
