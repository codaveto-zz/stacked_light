import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class SizeReporter extends SingleChildRenderObjectWidget {
  const SizeReporter({Key? key, required Widget child, required this.onSizeChanged})
      : super(key: key, child: child);
  final void Function(Size size) onSizeChanged;

  @override
  _SizeReporterRenderObject createRenderObject(BuildContext context) =>
      _SizeReporterRenderObject(onSizeChanged);

  @override
  void updateRenderObject(BuildContext context, covariant _SizeReporterRenderObject renderObject) {
    renderObject.onSizeChanged = onSizeChanged;
  }
}

class _SizeReporterRenderObject extends RenderProxyBox {
  _SizeReporterRenderObject(this.onSizeChanged);
  void Function(Size size) onSizeChanged;

  Size? _oldSize;

  @override
  void performLayout() {
    super.performLayout();
    if (size != _oldSize) {
      _oldSize = size;
      onSizeChanged(size);
    }
  }
}
