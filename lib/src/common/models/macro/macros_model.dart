class Macros {
  Macros({required int caloriesTarget, required int carbsPercent, required int proteinPercent, required int fatPercent}) {
    if (caloriesTarget >= 0 && carbsPercent >= 0 && proteinPercent >= 0 && fatPercent >= 0 && (carbsPercent + proteinPercent + fatPercent == 100)) {
      this.caloriesTarget = caloriesTarget;
      this.carbsPercent = carbsPercent;
      this.proteinPercent = proteinPercent;
      this.fatPercent = fatPercent;
    } else {
      return;
    }
  }

  /// [_caloriesTarget] default is 2100 and it is private member. so it will not accessible directly.
  int _caloriesTarget = 2100;

  /// [caloriesTarget] is setter for the [_caloriesTarget] member.
  /// If the calories value is less than 0 then replace it with the 0.
  set caloriesTarget(int calories) {
    if (calories < 0) {
      _caloriesTarget = 0;
    } else {
      _caloriesTarget = calories;
    }
  }

  /// [_carbsPercent] is private member and default value is 55.
  int _carbsPercent = 55;

  int get carbsPercent => _carbsPercent;

  /// [carbsPercent] is setter for the [_carbsPercent].
  set carbsPercent(int carbs) {
    final values = (balance3Values(first: carbs, second: _proteinPercent, third: _fatPercent));
    _carbsPercent = values.$1;
    _proteinPercent = values.$2;
    _fatPercent = values.$3;
  }

  /// [_proteinPercent] is private member and default value is 20.
  int _proteinPercent = 20;

  int get proteinPercent => _proteinPercent;

  /// [proteinPercent] is setter for the [_proteinPercent].
  set proteinPercent(int protein) {
    final values = (balance3Values(first: protein, second: _fatPercent, third: _carbsPercent));
    _proteinPercent = values.$1;
    _fatPercent = values.$2;
    _carbsPercent = values.$3;
  }

  /// [_fatPercent] is private member and default value is 25.
  int _fatPercent = 25;

  /// [fatPercent] is setter for the [_fatPercent].
  set fatPercent(int fat) {
    final values = (balance3Values(first: fat, second: _proteinPercent, third: _carbsPercent));
    _fatPercent = values.$1;
    _proteinPercent = values.$2;
    _carbsPercent = values.$3;
  }

  int get fatPercent => _fatPercent;

  /// [carbsGram] is [int] so it calculates the carbs in gram.
  int get carbsGram => _caloriesTarget * _carbsPercent / 100 ~/ 4;

  /// [proteinGram] is [int] so it calculates the carbs in gram.
  int get proteinGram => _caloriesTarget * _proteinPercent / 100 ~/ 4;

  /// [fatGrams] is [int] so it calculates the carbs in gram.
  int get fatGrams => _caloriesTarget * _fatPercent / 100 ~/ 9;

  (int, int, int) balance3Values({required int first, required int second, required int third}) {
    final validateFirst = _validatePercent(value: first);
    if ((validateFirst + third) > 100) {
      return (validateFirst, 0, 100 - validateFirst);
    } else {
      return (validateFirst, 100 - validateFirst - third, third);
    }
  }

  int _validatePercent({required int value}) {
    return switch(value) {
      > 100 => 100,
      < 0 => 0,
      _ => value,
    };
  }
}
