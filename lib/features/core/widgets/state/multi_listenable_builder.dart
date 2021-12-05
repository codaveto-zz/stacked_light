import 'package:flutter/widgets.dart';

class MultiListenableBuilder extends StatefulWidget {
  final Widget? child;
  final List<Listenable>? listenables;
  final Widget Function(BuildContext context, Widget? child) builder;

  const MultiListenableBuilder({
    Key? key,
    required this.listenables,
    required this.builder,
    this.child,
  }) : super(key: key);

  @override
  _MultiListenableBuilderState createState() => _MultiListenableBuilderState();
}

class _MultiListenableBuilderState extends State<MultiListenableBuilder> {
  late List<Listenable> _listenables;

  void _rebuild() => setState(() {});

  @override
  void initState() {
    super.initState();
    _listenables = widget.listenables ?? [];
    for (final l in _listenables) l.addListener(_rebuild);
  }

  @override
  void didUpdateWidget(MultiListenableBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.listenables == null) {
      for (final l in _listenables) l.removeListener(_rebuild);
      _listenables.clear();
    } else {
      for (final l in widget.listenables!) {
        if (!_listenables.contains(l)) {
          _listenables.add(l);
          l.addListener(_rebuild);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, widget.child);
  }

  @override
  void dispose() {
    for (final l in _listenables) l.removeListener(_rebuild);
    super.dispose();
  }
}
