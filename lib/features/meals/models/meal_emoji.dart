enum MealEmoji {
  // Proteins
  chicken('🍗'),
  meat('🥩'),
  fish('🐟'),
  shrimp('🍤'),
  eggs('🍳'),
  tofu('🥬'),
  milk('🥛'),

  // Carbs & Grains
  oats('🥣'),
  rice('🍚'),
  bread('🍞'),
  sweetPotato('🍠'),
  pasta('🍝'),

  // Fruits & Veggies
  broccoli('🥦'),
  salad('🥗'),
  avocado('🥑'),
  banana('🍌'),
  fruit('🍎'),

  // Drinks & Supplements
  shake('🥤'),
  coffee('☕'),
  water('💧'),
  supplement('💊'),

  // Meals & Snacks
  snack('🥨'),
  nuts('🥜'),
  dinner('🥘'),
  generic('🍽️'),

  // "Cheat" / Treats
  pizza('🍕'),
  burger('🍔'),
  iceCream('🍦');

  final String value;
  const MealEmoji(this.value);
}
