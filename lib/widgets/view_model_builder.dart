import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../abstract/base_view_model.dart';

enum _ViewModelBuilderTypes { nonReactive, reactive }

class ViewModelBuilder<T extends BaseViewModel> extends StatefulWidget {
  const ViewModelBuilder.nonReactive({
    required this.viewModelBuilder,
    required this.builder,
    this.onDispose,
    this.disposeViewModel = true,
    this.createNewModelOnInsert = false,
    this.fireInitialiseOnlyOnce = false,
    Key? key,
  })  : viewModelBuilderType = _ViewModelBuilderTypes.nonReactive,
        child = null,
        super(key: key);

  const ViewModelBuilder.reactive({
    required this.viewModelBuilder,
    required this.builder,
    this.child,
    this.onDispose,
    this.disposeViewModel = true,
    this.createNewModelOnInsert = false,
    this.fireInitialiseOnlyOnce = false,
    Key? key,
  })  : viewModelBuilderType = _ViewModelBuilderTypes.reactive,
        super(key: key);

  final Widget? child;
  final Widget Function(BuildContext context, T model, Widget? child) builder;
  final T Function() viewModelBuilder;
  final bool disposeViewModel;
  final bool createNewModelOnInsert;
  final _ViewModelBuilderTypes viewModelBuilderType;
  final bool fireInitialiseOnlyOnce;
  final Function(T model)? onDispose;

  @override
  _ViewModelBuilderState<T> createState() => _ViewModelBuilderState<T>();
}

class _ViewModelBuilderState<T extends BaseViewModel> extends State<ViewModelBuilder<T>> {
  T? _viewModel;

  @override
  void initState() {
    if (_viewModel == null) {
      _createViewModel();
    } else if (widget.createNewModelOnInsert) {
      _createViewModel();
    }
    super.initState();
  }

  @override
  void dispose() {
    widget.onDispose?.call(_viewModel!);
    super.dispose();
  }

  void _createViewModel() {
    _viewModel = widget.viewModelBuilder();
    if ((widget.fireInitialiseOnlyOnce && !(_viewModel as BaseViewModel).isInitialised) ||
        !widget.fireInitialiseOnlyOnce) {
      _viewModel!.initialise();
    }
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.viewModelBuilderType) {
      case _ViewModelBuilderTypes.nonReactive:
        if (!widget.disposeViewModel) {
          return ChangeNotifierProvider<T>.value(
            value: _viewModel!,
            child: widget.builder(context, _viewModel!, widget.child),
          );
        } else {
          return ChangeNotifierProvider<T>(
            create: (context) => _viewModel!,
            child: widget.builder(context, _viewModel!, widget.child),
          );
        }
      case _ViewModelBuilderTypes.reactive:
        if (!widget.disposeViewModel) {
          return ChangeNotifierProvider<T>.value(
            value: _viewModel!,
            child: Consumer<T>(
              builder: widget.builder,
              child: widget.child,
            ),
          );
        } else {
          return ChangeNotifierProvider<T>(
            create: (context) => _viewModel!,
            child: Consumer<T>(
              builder: widget.builder,
              child: widget.child,
            ),
          );
        }
    }
  }
}
