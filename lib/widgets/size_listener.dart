import 'package:flutter/material.dart';

class SizeListenerWidget extends StatefulWidget {
  final Widget child;
  final ValueChanged<Size> onSizeChange;
  const SizeListenerWidget({
    super.key,
    required this.child,
    required this.onSizeChange,
  });

  @override
  State<SizeListenerWidget> createState() => _SizeListenerWidgetState();
}

class _SizeListenerWidgetState extends State<SizeListenerWidget> {
  Size? _oldSize;

  void _notifySize() {
    if (!mounted) return;

    final size = context.size;
    if (size != null && _oldSize != size) {
      _oldSize = size;
      widget.onSizeChange(size);
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _notifySize());
    return widget.child;
  }
}
