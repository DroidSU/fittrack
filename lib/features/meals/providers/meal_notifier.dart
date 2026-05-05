import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../models/meals.dart';

class MealNotifier extends Notifier<List<Meals>> {

  late Box box;

  @override
  List<Meals> build() {
    
    box = Hive.box("mealsBox");

    final mealsData = box.get("meals", defaultValue:  []) as List;
    
    return mealsData.map((item) {
      return Meals(id: item["id"], name: item["name"], protein: item["protein"]);
    }).toList();
  }

  void addMeal(Meals meal) {
    final updatedState = [...state, meal];
    state = updatedState;

    _saveToDb(updatedState);
  }

  void removeMeal(int index) {
    final updatedState = [...state]..removeAt(index);
    state = updatedState;

    _saveToDb(updatedState);
  }

  double get totalProtein {
    return state.fold(0, (sum, meal) => sum + meal.protein);
  }


  void _saveToDb(List<Meals> meals) {
    final data = meals.map((m) {
      return {
        'id': m.id,
        'name': m.name,
        'protein': m.protein,
      };
    }).toList();

    box.put('meals', data);
  }

}

final mealProvider = NotifierProvider<MealNotifier, List<Meals>>(
  MealNotifier.new,
);

final totalProteinProvider = Provider<double>((ref) {
  ref.watch(mealProvider);
  return ref.read(mealProvider.notifier).totalProtein;
});
