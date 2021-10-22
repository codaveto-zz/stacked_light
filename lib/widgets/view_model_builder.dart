import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../state/base_view_model.dart';

enum _ViewModelBuilderTypes { nonReactive, reactive }

/// A widget that provides base functionality for the Mvvm style provider architecture by FilledStacks.
class ViewModelBuilder<T extends BaseViewModel> extends StatefulWidget {
  /// Constructs a ViewModel provider that will not rebuild the provided widget when notifyListeners is called.
  ///
  /// Widget from [builder] will be used as a static child and won't rebuild when notifyListeners is called
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

  /// Constructs a ViewModel provider that fires the [builder] function when notifyListeners is called in the ViewModel.
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

  /// Child that won't rebuild when notifyListeners is called.
  final Widget? child;

  /// Builder function with access to the ViewModel to build UI form
  final Widget Function(BuildContext context, T model, Widget? child) builder;

  /// A builder function that returns the ViewModel for this widget
  final T Function() viewModelBuilder;

  /// Indicates if you want Provider to dispose the ViewModel when it's removed from the widget tree.
  ///
  /// default's to true
  final bool disposeViewModel;

  /// When set to true a new ViewModel will be constructed everytime the widget is inserted.
  ///
  /// When setting this to true make sure to handle all disposing of streams if subscribed
  /// to any in the ViewModel. [onModelReady] will fire once the ViewModel has been created/set.
  /// This will be used when on re-insert of the widget the ViewModel has to be constructed with
  /// a new value.
  final bool createNewModelOnInsert;

  final _ViewModelBuilderTypes viewModelBuilderType;

  /// Indicates if we should run the initialise functionality only once
  final bool fireInitialiseOnlyOnce;

  /// Fires when the widget has been removed from the widget tree and allows you to dispose
  /// of any controllers or state values that need disposing
  final Function(T model)? onDispose;

  @override
  _ViewModelBuilderState<T> createState() => _ViewModelBuilderState<T>();
}

class _ViewModelBuilderState<T extends BaseViewModel> extends State<ViewModelBuilder<T>> {
  T? _viewModel;

  @override
  void initState() {
    // We want to ensure that we only build the ViewModel if it hasn't been built yet.
    if (_viewModel == null) {
      _createViewModel();
    }
    // Or if the user wants to create a new ViewModel whenever initState is fired
    else if (widget.createNewModelOnInsert) {
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
