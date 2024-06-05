extension MapExt on Map {
  T? ifValueNotNull<T>(String key, T Function(Map<String, dynamic> map) op) {
    if (!containsKey(key)) {
      return null;
    }

    var value = (this[key] as Map<Object?, Object?>?)?.cast<String, dynamic>();
    if (value == null) {
      return null;
    }

    return op(value);
  }
}

extension SortBy<K, V> on Map<K, V> {
  /// Sorts the map entries based on a provided comparator function.
  ///
  /// The comparator function takes two key-value pairs (MapEntry) and
  /// should return a negative value if the first entry comes before the
  /// second, a positive value if it comes after, and zero if they are
  /// equal.
  Map<K, V> sortBy(Comparator<MapEntry<K, V>> comparator) {
    final entries = this.entries.toList()..sort(comparator);
    return Map.fromEntries(entries);
  }
}
