extension NullSafetyExtension<T> on T? {
  R? let<R>(R Function(T) block) {
    final value = this;
    if (value == null) {
      return null;
    }
    return block.call(value);
  }
}
