# scrollable_tab

A Flutter library for creating scrollable tab views with headers and items. This library provides a controller to manage the state and behavior of the tabs and scroll view, enabling smooth scrolling and tab selection interactions.

## Features

- Scrollable tabs with headers and items.
- Customizable tab headers, group headers, and item builders.
- Smooth scrolling and tab selection synchronization.

## Installation

```yaml
dependencies:
  scrollable_tab: any
```

Then, run `flutter pub get` to install the package.

## Usuage

### Import the library

```dart
import 'package:scrollable_tab/scrollable_tab.dart';
```

### Define your tab header items

```dart
import 'package:scrollable_tab/scrollable_tab';

final tabItems = [
  TabHeaderItems(
    name: 'Tab 1',
    items: ['Item 1.1', 'Item 1.2', 'Item 1.3'],
  ),
  TabHeaderItems(
    name: 'Tab 2',
    items: ['Item 2.1', 'Item 2.2'],
  ),
  // Add more tabs as needed
];
```

### Create the ScrollableTabView

```dart
import 'package:flutter/material.dart';
import 'package:scrollable_tab/scrollable_tab.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Scrollable Tab View')),
        body: ScrollableTabView<String>(
          tabItems: tabItems,
          tabHeaderBuilder: (tabInfo) => Tab(text: tabInfo.header.name),
          groupHeaderBuilder: (header) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              header.name,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          itemBuilder: (item) => ListTile(title: Text(item)),
        ),
      ),
    );
  }
}

void main() => runApp(MyApp());
```

### Custom Controller

If you need to customize the controller or use an existing `ScrollController`, you can create the `ScrollableTabView` with a custom controller.

```dart
final customController = ScrollableTabController<String>(tabItems: tabItems);

ScrollableTabView<String>(
  controller: customController,
  tabHeaderBuilder: (tabInfo) => Tab(text: tabInfo.header.name),
  groupHeaderBuilder: (header) => Padding(
    padding: const EdgeInsets.all(8.0),
    child: Text(
      header.name,
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    ),
  ),
  itemBuilder: (item) => ListTile(title: Text(item)),
);
```

### Call init and dispose

Make sure to call init method of the `ScrollableTabController` in order to intialize the `ScrollController` and `TabController`

```dart
customController.init(this);
```

Note: `this` is a TickerProvider which comes from `TickerProviderStateMixin` class.

Carefully dispose the controller in the dispose method.

```dart
customController.dispose();
```

## API Reference

### `TabHeaderItems<T>`

A class that represents the header items for each tab.

- `name`: The name of the tab header.
- `extras`: Additional data for the header.
- `items`: A list of items under this header.

### `ScrollableTabController<T>`

A controller for managing the state and behavior of the scrollable tab view.

- `tabItems`: The list of tab header items.
- `scrollController`: An optional external `ScrollController`.

### `ScrollableTabView<T>`

A widget that provides a scrollable tab view.

- `tabItems`: The list of tab header items.
- `tabHeaderBuilder`: A builder for creating tab headers.
- `groupHeaderBuilder`: A builder for creating group headers.
- `itemBuilder`: A builder for creating items.
- `controller`: An optional custom `ScrollableTabController`.
- `_scrollController`: An optional custom `ScrollController`.

## Example

```dart
import 'package:flutter/material.dart';
import 'package:scrollable_tab_view/scrollable_tab_view.dart';
import 'package:scrollable_tab_view/model/tab_header_items.dart';

final tabItems = [
  TabHeaderItems(
    name: 'Tab 1',
    items: ['Item 1.1', 'Item 1.2', 'Item 1.3'],
  ),
  TabHeaderItems(
    name: 'Tab 2',
    items: ['Item 2.1', 'Item 2.2'],
  ),
  // Add more tabs as needed
];

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Scrollable Tab View')),
        body: ScrollableTabView<String>(
          tabItems: tabItems,
          tabHeaderBuilder: (tabInfo) => Tab(text: tabInfo.header.name),
          groupHeaderBuilder: (header) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              header.name,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          itemBuilder: (item) => ListTile(title: Text(item)),
        ),
      ),
    );
  }
}

void main() => runApp(MyApp());
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
