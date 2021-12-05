import 'package:flutter/widgets.dart';

typedef FutureCallback = Future Function();

class BindingObserver extends StatefulWidget {
  const BindingObserver({
    required this.builder,
    Key? key,
    this.resumedCallbacks,
  }) : super(key: key);

  final List<FutureCallback>? resumedCallbacks;
  final WidgetBuilder builder;

  @override
  _BindingObserverState createState() => _BindingObserverState();
}

class _BindingObserverState extends State<BindingObserver> with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance?.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    widget.resumedCallbacks?.clear();
    super.dispose();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        for (int x = 0; x < (widget.resumedCallbacks?.length ?? 0); x++) {
          await widget.resumedCallbacks![x].call();
        }
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) => widget.builder(context);
}
