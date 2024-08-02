part of '../scrollable_tab.dart';

typedef TabHeaderBuilder<T> = Widget Function(TabInfo<T> header);

typedef GroupHeaderBuilder<T> = Widget Function(TabHeaderItems<T> header);

typedef ItemBuilder<T> = Widget Function(T item);

/// A widget that provides a scrollable tab view with headers and items.
///
/// The [ScrollableTabView] supports both default and custom controllers for managing
/// the state and behavior of the tabs and scroll view.
class ScrollableTabView<T> extends StatefulWidget {
  /// Creates a [ScrollableTabView] with the provided tab items and builders.
  const ScrollableTabView({
    super.key,
    required this.tabItems,
    required this.tabHeaderBuilder,
    required this.groupHeaderBuilder,
    required this.itemBuilder,
  })  : controller = null,
        _scrollController = null;

  /// Creates a [ScrollableTabView] with a custom controller and optional scroll controller.
  const ScrollableTabView.custom({
    super.key,
    required this.tabHeaderBuilder,
    required this.groupHeaderBuilder,
    required this.itemBuilder,
    this.controller,
    ScrollController? scrollController,
  })  : tabItems = const [],
        _scrollController = scrollController;

  /// The controller for managing the tab view's state.
  final ScrollableTabController<T>? controller;

  /// The optional scroll controller for the list view.
  final ScrollController? _scrollController;

  /// The list of tab items.
  final List<TabHeaderItems<T>> tabItems;

  /// The builder for creating tab headers.
  final TabHeaderBuilder<T> tabHeaderBuilder;

  /// The builder for creating group headers.
  final GroupHeaderBuilder<T> groupHeaderBuilder;

  /// The builder for creating items.
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

  bool _hideOffsetWidget = false;

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

  /// Calculates the initial sizes of the header and item extents after the first frame.
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
      _hideOffsetWidget = true;
      _controller.calculateOffset(headerExtent, itemExtent);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant ScrollableTabView<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    oldWidget.controller?.scrollController
        .removeListener(oldWidget.controller!._onScrollListener);
    widget.controller?.addListener(widget.controller!._onScrollListener);
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
        if (!_hideOffsetWidget) {
          return Offstage(
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
          );
        }
        return Column(
          children: [
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
