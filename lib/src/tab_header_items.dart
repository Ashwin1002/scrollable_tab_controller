part of '../scrollable_tab.dart';

/// A generic class that represents items under a tab header.
///
/// This class is typically used in scenarios where you have tabbed views
/// and each tab has a name, an optional set of extra data, and a list of items
/// associated with it.
///
/// The type parameter [T] represents the type of items in the list.
///
/// Example usage:
/// ```dart
/// final tab = TabHeaderItems<String>(
///   name: 'Tab 1',
///   extras: {'key': 'value'},
///   items: ['Item 1', 'Item 2'],
/// );
/// ```
class TabHeaderItems<T> {
  /// The name of the tab header.
  final String name;

  /// A map of additional data associated with the tab header.
  ///
  /// This can be used to store any extra information that might be useful
  /// for the tab, such as metadata or configuration options.
  final Map<String, dynamic>? extras;

  /// A list of items associated with the tab header.
  ///
  /// The type of items is generic and determined by the type parameter [T].
  final List<T> items;

  /// Creates a new instance of [TabHeaderItems].
  ///
  /// Both [name] and [items] are required. The [extras] parameter is optional.
  const TabHeaderItems({
    required this.name,
    this.extras,
    required this.items,
  });

  /// Creates a copy of this [TabHeaderItems] instance with optional new values.
  ///
  /// The [copyWith] method can be used to create a modified copy of the
  /// current instance while preserving the original values for fields that
  /// are not specified.
  ///
  /// Example usage:
  /// ```dart
  /// final newTab = tab.copyWith(name: 'New Tab 1');
  /// ```
  TabHeaderItems<T> copyWith({
    String? name,
    Map<String, dynamic>? extras,
    List<T>? items,
  }) {
    return TabHeaderItems<T>(
      name: name ?? this.name,
      extras: extras ?? this.extras,
      items: items ?? this.items,
    );
  }
}
