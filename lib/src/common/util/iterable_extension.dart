extension IterableExtension<T> on Iterable<T> {
  List<T> distinct<U>({required U Function(T t) by}) {
    final unique = <U, T>{};

    for (final item in this) {
      unique.putIfAbsent(by(item), () => item);
    }

    return unique.values.toList();
  }

  Map<S, List<T>> groupBy<S>(S Function(T) key) {
    final map = <S, List<T>>{};
    for (var element in this) {
      (map[key(element)] ??= []).add(element);
    }
    return map;
  }
}
