import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

/// Contains ViewModel functionality for busy state management
abstract class BaseViewModel extends ChangeNotifier {
  bool _isInitialised = false;
  bool get isInitialised => _isInitialised;

  bool _isDisposed = false;
  bool get isDisposed => _isDisposed;

  final ValueNotifier<bool> _isBusy = ValueNotifier(false);
  ValueListenable<bool> get isBusy => _isBusy;

  final ValueNotifier<bool> _hasError = ValueNotifier(false);
  ValueListenable<bool> get hasError => _hasError;

  @mustCallSuper
  void initialise() {
    _isInitialised = true;
    notifyListeners();
  }

  /// Marks the ViewModel as busy and calls notify listeners
  void setBusy(bool value) => _isBusy.value = value;

  /// Sets the error for the ViewModel
  void setError(bool value) => _hasError.value = value;

  /// Sets the ViewModel to busy, runs the future and then sets it to not busy when complete.
  ///
  /// rethrows [Exception] after setting busy to false for object or class
  Future<T> runBusyFuture<T>(Future<T> busyFuture) async {
    try {
      setBusy(true);
      return await busyFuture;
    } catch (e) {
      rethrow;
    } finally {
      setBusy(false);
    }
  }

  @override
  void notifyListeners() {
    if (!isDisposed) {
      super.notifyListeners();
    }
  }

  @mustCallSuper
  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
