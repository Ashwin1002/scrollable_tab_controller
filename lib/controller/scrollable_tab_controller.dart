import 'package:flutter/material.dart';

import 'package:scrollable_tab/model/tab_header_items.dart';

class ScrollableTabController<T> with ChangeNotifier {
  ScrollableTabController({
    required this.tabItems,
    ScrollController? scrollController,
  }) : _scrollController = scrollController;

  final List<TabHeaderItems<T>> tabItems;
  final ScrollController? _scrollController;

  List<TabInfo<T>> tabs = [];

  List<TabItem<T>> items = [];

  late TabController _tabController;

  late ScrollController _controller;

  TabController get tabController => _tabController;

  ScrollController get scrollController => _controller;

  bool _listen = true;

  void init(
    TickerProvider ticker, {
    double itemExtent = 0,
    double headerExtent = 0,
  }) {
    _controller = _scrollController ?? ScrollController();

    _tabController = TabController(
      length: tabItems.length,
      vsync: ticker,
    );

    for (int i = 0; i < tabItems.length; i++) {
      final tabHeader = tabItems[i];
      tabs.add(
        TabInfo(
          header: tabHeader,
          selected: (i == 0),
          offsetFrom: 0,
          offsetTo: 0,
        ),
      );

      // Add header and its items to the items list.
      items.add(TabItem(header: tabHeader));
      items.addAll(tabHeader.items.map((detail) => TabItem(detail: detail)));
    }
  }

  void calculateOffset(double headerExtent, double itemExtent) {
    double offsetFrom = 0.0;
    double offsetTo = 0.0;

    for (int i = 0; i < tabItems.length; i++) {
      if (i > 0) {
        offsetFrom += tabItems[i - 1].items.length * itemExtent + headerExtent;
      }

      offsetTo = (i < tabItems.length - 1)
          ? offsetFrom +
              tabItems[i + 1].items.length * itemExtent +
              headerExtent
          : double.infinity;

      // Update the existing tab with new offsets.
      tabs[i] = tabs[i].copyWith(
        offsetFrom: offsetFrom,
        offsetTo: offsetTo,
      );
    }

    _controller.addListener(_onScrollListener);
  }

  void _onScrollListener() {
    if (_listen) {
      for (int i = 0; i < tabs.length; i++) {
        final tab = tabs[i];

        if (_controller.offset >= tab.offsetFrom &&
            _controller.offset <= tab.offsetTo &&
            !tab.selected) {
          onCategorySelected(i, isAnimationRequired: false);
          _tabController.animateTo(i);
          break;
        }
      }
    }
  }

  void onCategorySelected(
    int index, {
    bool isAnimationRequired = true,
  }) async {
    final selected = tabs[index];
    for (int i = 0; i < tabs.length; i++) {
      final condition = selected.header.name == tabs[i].header.name;
      tabs[i] = tabs[i].copyWithSelected(condition);
    }
    notifyListeners();

    if (isAnimationRequired) {
      _listen = false;
      await _controller.animateTo(
        selected.offsetFrom,
        duration: const Duration(milliseconds: 500),
        curve: Curves.linear,
      );
    }
    _listen = true;
  }

  @override
  void dispose() {
    _tabController.dispose();
    _controller.removeListener(_onScrollListener);
    if (_scrollController == null) {
      _controller.dispose();
    }
    super.dispose();
  }
}

class TabInfo<T> {
  final TabHeaderItems<T> header;
  final bool selected;
  final double offsetFrom;
  final double offsetTo;

  TabInfo<T> copyWithSelected(bool selected) => TabInfo<T>(
        header: header,
        selected: selected,
        offsetFrom: offsetFrom,
        offsetTo: offsetTo,
      );

  TabInfo({
    required this.header,
    required this.selected,
    required this.offsetFrom,
    required this.offsetTo,
  });

  TabInfo<T> copyWith({
    TabHeaderItems<T>? header,
    bool? selected,
    double? offsetFrom,
    double? offsetTo,
  }) {
    return TabInfo<T>(
      header: header ?? this.header,
      selected: selected ?? this.selected,
      offsetFrom: offsetFrom ?? this.offsetFrom,
      offsetTo: offsetTo ?? this.offsetTo,
    );
  }
}

class TabItem<T> {
  const TabItem({
    this.header,
    this.detail,
  });

  bool get isHeader => header != null;
  final TabHeaderItems<T>? header;
  final T? detail;
}
