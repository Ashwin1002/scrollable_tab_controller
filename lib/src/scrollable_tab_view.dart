import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:scrollable_tab/controller/scrollable_tab_controller.dart';
import 'package:scrollable_tab/model/tab_header_items.dart';

typedef TabHeaderBuilder<T> = Widget Function(TabInfo<T> header);
typedef GroupHeaderBuilder<T> = Widget Function(TabHeaderItems<T> header);
typedef ItemBuilder<T> = Widget Function(T item);

class ScrollableTabView<T> extends StatefulWidget {
  const ScrollableTabView({
    super.key,
    required this.tabItems,
    required this.tabHeaderBuilder,
    required this.groupHeaderBuilder,
    required this.itemBuilder,
  })  : controller = null,
        _scrollController = null;

  const ScrollableTabView.custom({
    super.key,
    required this.tabHeaderBuilder,
    required this.groupHeaderBuilder,
    required this.itemBuilder,
    this.controller,
    ScrollController? scrollController,
  })  : tabItems = const [],
        _scrollController = scrollController;

  final ScrollableTabController<T>? controller;
  final ScrollController? _scrollController;
  final List<TabHeaderItems<T>> tabItems;
  final TabHeaderBuilder<T> tabHeaderBuilder;
  final GroupHeaderBuilder<T> groupHeaderBuilder;
  final ItemBuilder<T> itemBuilder;

  @override
  State<ScrollableTabView<T>> createState() => _ScrollableTabViewState<T>();
}

class _ScrollableTabViewState<T> extends State<ScrollableTabView<T>>
    with SingleTickerProviderStateMixin {
  late final ScrollableTabController<T> _controller;

  double itemExtent = 0;
  double headerExtent = 0;

  final GlobalKey _headerKey = GlobalKey();
  final GlobalKey _itemKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ??
        ScrollableTabController(
          tabItems: widget.tabItems,
          scrollController: widget._scrollController,
        );
    _controller.init(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _calculateInitialSizes();
    });
  }

  void _calculateInitialSizes() {
    final headerContext = _headerKey.currentContext;
    final itemContext = _itemKey.currentContext;

    if (headerContext != null) {
      final headerRenderBox = headerContext.findRenderObject() as RenderBox;
      setState(() {
        headerExtent = headerRenderBox.size.height;
      });
    }

    if (itemContext != null) {
      final itemRenderBox = itemContext.findRenderObject() as RenderBox;
      setState(() {
        itemExtent = itemRenderBox.size.height;
      });
    }

    log('item extent => $itemExtent\nheader extent => $headerExtent');

    if (headerExtent != 0 && itemExtent != 0) {
      _controller.calculateOffset(headerExtent, itemExtent);
    }
  }

  @override
  void didUpdateWidget(covariant ScrollableTabView<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        return Column(
          children: [
            Offstage(
              offstage: true,
              child: Column(
                children: [
                  SizedBox(
                    key: _headerKey,
                    child: _controller.tabItems.isNotEmpty
                        ? widget.groupHeaderBuilder(_controller.tabItems.first)
                        : const SizedBox.shrink(),
                  ),
                  SizedBox(
                    key: _itemKey,
                    child: widget.tabItems.isNotEmpty &&
                            widget.tabItems.first.items.isNotEmpty
                        ? widget.itemBuilder(widget.tabItems.first.items.first)
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
            TabBar(
              onTap: _controller.onCategorySelected,
              controller: _controller.tabController,
              isScrollable: true,
              indicatorWeight: .1,
              indicatorColor: Colors.transparent,
              tabs: _controller.tabs
                  .map((e) => widget.tabHeaderBuilder(e))
                  .toList(),
              labelColor: Colors.transparent,
              splashFactory: NoSplash.splashFactory,
            ),
            Flexible(
              child: ListView.builder(
                controller: _controller.scrollController,
                itemCount: _controller.items.length,
                itemBuilder: (context, index) {
                  final item = _controller.items[index];

                  if (item.isHeader) {
                    return item.header != null
                        ? widget.groupHeaderBuilder(item.header!)
                        : const SizedBox.shrink();
                  } else {
                    return item.detail != null
                        ? widget.itemBuilder(item.detail as T)
                        : const SizedBox.shrink();
                  }
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
