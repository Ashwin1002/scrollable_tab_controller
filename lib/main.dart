import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:scrollable_tab/demo_list.dart';
import 'package:scrollable_tab/model/tab_header_items.dart';
import 'package:scrollable_tab/src/scrollable_tab_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Scrollable Tab Demo',
      theme: ThemeData(
        colorScheme: const ColorScheme.light(
          onPrimary: Colors.deepPurple,
        ),
        useMaterial3: true,
      ),
      home: const HomePage(
        title: 'Scrollable Tab Example',
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    required this.title,
  });

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var data = <TabHeaderItems<String>>[];

  @override
  void initState() {
    super.initState();
    data = demoData.entries.map((entry) {
      return TabHeaderItems<String>(
        name: entry.key,
        items: entry.value,
      );
    }).toList();

    log('data => $data');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: ScrollableTabView<String>(
        tabItems: data,
        tabHeaderBuilder: (tab) => Card(
          color: tab.selected ? Colors.deepPurple.shade300 : null,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              tab.header.name,
            ),
          ),
        ),
        groupHeaderBuilder: (header) => Container(
          color: Colors.grey.shade500,
          width: MediaQuery.sizeOf(context).width,
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            header.name,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        itemBuilder: (item) {
          return Container(
            width: MediaQuery.sizeOf(context).width,
            padding: const EdgeInsets.symmetric(
              vertical: 12.0,
              horizontal: 14.0,
            ),
            alignment: Alignment.centerLeft,
            child: Text(
              item,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          );
        },
      ),
    );
  }
}
