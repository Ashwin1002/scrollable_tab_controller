import 'package:flutter/material.dart';
import 'package:scrollable_tab/scrollable_tab.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scrollable Tab Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Scrollable Tab Demo Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final tabItems = [
    TabHeaderItems(name: 'Tab 1', items: ['Item 1.1', 'Item 1.2', 'Item 1.3']),
    TabHeaderItems(name: 'Tab 2', items: ['Item 2.1', 'Item 2.2']),
    TabHeaderItems(
      name: 'Tab 3',
      items: ['Item 3.1', 'Item 3.2', 'Item 3.4', 'Item 3.5'],
    ),
    TabHeaderItems(name: 'Tab 4', items: ['Item 4.1', 'Item 4.2', 'Item 4.3']),
    TabHeaderItems(name: 'Tab 5', items: ['Item 5.1']),
    TabHeaderItems(
      name: 'Tab 6',
      items: [
        'Item 6.1',
        'Item 6.2',
        'Item 6.3',
        'Item 6.4',
        'Item 6.5',
        'Item 6.6',
      ],
    ),
    TabHeaderItems(name: 'Tab 7', items: ['Item 7.1', 'Item 7.2']),
    // Add more tabs as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: ScrollableTabView<String>(
        tabItems: tabItems,
        tabHeaderBuilder: (tabInfo) => Tab(text: tabInfo.header.name),
        groupHeaderBuilder:
            (header) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                header.name,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
        itemBuilder: (item) => ListTile(title: Text(item)),
      ),
    );
  }
}
