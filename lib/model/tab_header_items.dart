class TabHeaderItems<T> {
  final String name;
  final Map<String, dynamic>? extras;
  final List<T> items;

  const TabHeaderItems({
    required this.name,
    this.extras,
    required this.items,
  });

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
