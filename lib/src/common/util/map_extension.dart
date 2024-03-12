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
