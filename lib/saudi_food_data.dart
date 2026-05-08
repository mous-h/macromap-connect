class FoodItem {
  final String name;
  final int calories;
  final int protein;
  final String restaurant;

  const FoodItem(this.name, this.calories, this.protein, this.restaurant);
}

const List<FoodItem> saudiFoodDatabase = [
  FoodItem("Classic Shawarma", 420, 25, "Shawarma House"),
  FoodItem("Double Arabi Meal", 850, 45, "Shawarma House"),
  FoodItem("4pc Chicken Meal (Spicy)", 920, 52, "Albaik"),
  FoodItem("Big Mac", 550, 25, "McDonald's"),
  FoodItem("Chicken Burger", 410, 22, "Kudu"),
  FoodItem("Super Kudu", 620, 35, "Kudu"),
  FoodItem("Kabsa Chicken (Portion)", 650, 30, "Local"),
  FoodItem("Maestro Pepperoni (Small)", 700, 28, "Maestro Pizza"),
];
