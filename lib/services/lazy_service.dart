// @dart = 2.12

import '../abstract/custom_service.dart';

class LazyService<T extends CustomService> {
  LazyService(this.locateCallback);
  final T Function() locateCallback;
  late final T _service = locateCallback();
  bool? _serviceInitialised;

  T get service {
    _serviceInitialised ??= true;
    return _service;
  }

  void dispose() {
    if (_serviceInitialised ?? false) _service.dispose();
  }
}
