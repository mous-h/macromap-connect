class MealLog {
  final String id;
  final String userId;
  final String mealType; // breakfast, lunch, dinner, snack
  final String foodName;
  final int calories;
  final int protein;
  final DateTime loggedAt;
  final String dateKey; // YYYY-MM-DD

  MealLog({
    required this.id,
    required this.userId,
    required this.mealType,
    required this.foodName,
    required this.calories,
    required this.protein,
    required this.loggedAt,
    required this.dateKey,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'mealType': mealType,
      'foodName': foodName,
      'calories': calories,
      'protein': protein,
      'loggedAt': loggedAt,
      'dateKey': dateKey,
    };
  }

  factory MealLog.fromMap(String id, Map<String, dynamic> map) {
    return MealLog(
      id: id,
      userId: map['userId'] ?? '',
      mealType: map['mealType'] ?? '',
      foodName: map['foodName'] ?? '',
      calories: map['calories'] ?? 0,
      protein: map['protein'] ?? 0,
      loggedAt: (map['loggedAt'] as dynamic).toDate(),
      dateKey: map['dateKey'] ?? '',
    );
  }
}
