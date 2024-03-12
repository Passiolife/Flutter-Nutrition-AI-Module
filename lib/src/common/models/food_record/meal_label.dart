/// Enum to represent different meal labels.
enum MealLabel {
  /// Represents breakfast meal.
  breakfast._('Breakfast'),

  /// Represents lunch meal.
  lunch._('Lunch'),

  /// Represents dinner meal.
  dinner._('Dinner'),

  /// Represents snack meal.
  snack._('Snack');

  /// The string value associated with each enum.
  final String value;

  /// Private constructor to initialize enum values with labels.
  const MealLabel._(this.value);

  /// Converts a string to [MealLabel] enum.
  ///
  /// Throws an [Exception] if the input text doesn't match any enum label.
  static MealLabel stringToMealLabel(String text) {
    return switch (text) {
      'Breakfast' => MealLabel.breakfast,
      'Lunch' => MealLabel.lunch,
      'Dinner' => MealLabel.dinner,
      'Snack' => MealLabel.snack,
      _ => throw Exception('No known MealLabel: $text'),
    };
  }

  /// Converts a [DateTime] to [MealLabel] enum based on the time of day.
  ///
  /// Returns [MealLabel.breakfast] if the time is between 5:30 AM and 10:30 AM,
  /// [MealLabel.lunch] if the time is between 11:30 AM and 2:00 PM,
  /// [MealLabel.dinner] if the time is between 5:00 PM and 9:00 PM,
  /// otherwise returns [MealLabel.snack].
  static MealLabel dateToMealLabel(DateTime dateTime) {
    final hours = dateTime.hour;
    final minutes = dateTime.minute;
    final timeOfDay = hours * 100 + minutes;
    return switch (timeOfDay) {
      (>= 530 && <= 1030) => MealLabel.breakfast,
      (>= 1130 && <= 1400) => MealLabel.lunch,
      (>= 1700 && <= 2100) => MealLabel.dinner,
      _ => MealLabel.snack,
    };
  }
}
