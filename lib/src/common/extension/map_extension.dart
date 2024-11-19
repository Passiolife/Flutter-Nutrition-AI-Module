extension MapExt on Map {
  /// Retrieves the value for [key] if it exists and is not null.
  /// Applies [transform] if provided, useful for nested maps.
  /// Returns `null` if [key] is missing or its value is null.
  T? ifValueNotNull<T>(String key,
      {T Function(Map<String, dynamic> map)? transform}) {
    // Check if the key exists in the map; if not, return null.
    if (!containsKey(key)) {
      return null;
    }

    // If no transform function is provided, return the value as T if it exists.
    if (transform == null) {
      return this[key] as T?;
    }

    // Attempt to cast the value to a Map and apply the transform function.
    var nestedMap =
        (this[key] as Map<Object?, Object?>?)?.cast<String, dynamic>();
    if (nestedMap == null) {
      return null;
    }

    // Apply the transform function to the nested map and return the result.
    return transform(nestedMap);
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