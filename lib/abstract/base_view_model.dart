import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

abstract class BaseViewModel extends ChangeNotifier {
  bool _isInitialised = false;
  bool get isInitialised => _isInitialised;

  bool _isDisposed = false;
  bool get isDisposed => _isDisposed;

  final ValueNotifier<bool> _isBusy = ValueNotifier(false);
  ValueListenable<bool> get isBusy => _isBusy;

  final ValueNotifier<bool> _hasError = ValueNotifier(false);
  ValueListenable<bool> get hasError => _hasError;

  String? _errorMessage;
  String get errorMessage {
    assert(_errorMessage != null, 'Set error message before requesting it.');
    return _errorMessage!;
  }

  @mustCallSuper
  void initialise() {
    _isInitialised = true;
    notifyListeners();
  }

  void setBusy(bool isBusy) => _isBusy.value = isBusy;

  void setError(bool hasError, [String? message]) {
    _errorMessage = hasError ? message : null;
    _hasError.value = hasError;
  }

  void clearError() => setError(false);

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

  @mustCallSuper
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
