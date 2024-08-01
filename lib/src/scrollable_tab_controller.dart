part of '../scrollable_tab.dart';

/// A controller for managing the state and behavior of a scrollable tab view.
///
/// This controller synchronizes a [TabController] and a [ScrollController]
/// to provide smooth scrolling and tab selection interactions.
class ScrollableTabController<T> with ChangeNotifier {
  /// Creates a [ScrollableTabController] with the given tab items.
  ///
  /// If [scrollController] is provided, it will be used; otherwise, a new
  /// [ScrollController] will be created.
  ScrollableTabController({
    required this.tabItems,
    ScrollController? scrollController,
  }) : _scrollController = scrollController;

  ///
  /// The list of tab items managed by this controller.
  ///
  final List<TabHeaderItems<T>> tabItems;

  /// The optional external [ScrollController].
  final ScrollController? _scrollController;

  /// The list of tabs with their metadata.
  List<TabInfo<T>> tabs = [];

  /// The flattened list of all tab items including headers and their details.
  List<TabItem<T>> items = [];

  /// The internal [TabController] for managing tab selection.
  late TabController _tabController;

  /// The internal [ScrollController] for managing scrolling.
  late ScrollController _controller;

  /// Gets the internal [TabController].
  TabController get tabController => _tabController;

  /// Gets the internal [ScrollController].
  ScrollController get scrollController => _controller;

  /// A flag to control whether the scroll listener should be active.
  bool _listen = true;

  /// Initializes the controller with the given [TickerProvider].
  ///
  /// [itemExtent] and [headerExtent] are used to determine the scroll extents
  /// for each tab and its items.
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

    // Initialize the tabs and items list
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

      // Add header and its items to the items list
      items.add(TabItem(header: tabHeader));
      items.addAll(tabHeader.items.map((detail) => TabItem(detail: detail)));
    }
  }

  /// Calculates the scroll offsets for each tab based on item and header extents.
  ///
  /// [headerExtent] and [itemExtent] are used to calculate the scrolling ranges.
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

      // Update the existing tab with new offsets
      tabs[i] = tabs[i].copyWith(
        offsetFrom: offsetFrom,
        offsetTo: offsetTo,
      );
    }

    _controller.addListener(_onScrollListener);
  }

  /// Listener for scroll events to update tab selection based on scroll position.
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

  /// Handles category selection and scrolls to the appropriate position.
  ///
  /// [index] is the index of the selected category. [isAnimationRequired] determines
  /// if the scroll animation should be performed.
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

/// Metadata and state for each tab.
class TabInfo<T> {
  /// Creates a [TabInfo] with the given parameters.
  TabInfo({
    required this.header,
    required this.selected,
    required this.offsetFrom,
    required this.offsetTo,
  });

  /// The header information for the tab.
  final TabHeaderItems<T> header;

  /// Whether the tab is currently selected.
  final bool selected;

  /// The scroll offset from which this tab starts.
  final double offsetFrom;

  /// The scroll offset to which this tab extends.
  final double offsetTo;

  /// Creates a copy of this [TabInfo] with a new selection state.
  ///
  /// [selected] is the new selection state.
  TabInfo<T> copyWithSelected(bool selected) => TabInfo<T>(
        header: header,
        selected: selected,
        offsetFrom: offsetFrom,
        offsetTo: offsetTo,
      );

  /// Creates a copy of this [TabInfo] with optional new values.
  ///
  /// [header], [selected], [offsetFrom], and [offsetTo] can be replaced with new values.
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

/// Represents either a header or a detail item in the tab view.
class TabItem<T> {
  /// Creates a [TabItem] which can be either a header or a detail item.
  const TabItem({
    this.header,
    this.detail,
  });

  /// Indicates if this item is a header.
  bool get isHeader => header != null;

  /// The header associated with this item, if any.
  final TabHeaderItems<T>? header;

  /// The detail item associated with this item, if any.
  final T? detail;
}
