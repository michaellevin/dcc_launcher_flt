import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:dcc_launcher/ui/list_item.dart';

class CustomListView extends StatelessWidget {
  final List<String> items;
  final ListItem Function(String) itemBuilder;

  const CustomListView(this.items, {Key? key, required this.itemBuilder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (BuildContext context, int index) {
        return itemBuilder(items[index]);
      },
    );
  }
}
