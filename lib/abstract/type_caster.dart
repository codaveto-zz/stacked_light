mixin TypeCaster<T> {
  E asType<E extends T>() => this as E;
}
