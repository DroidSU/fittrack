import 'package:fittrack/features/meals/models/meals.dart';
import 'package:fittrack/features/meals/providers/meal_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

class AddMealScreen extends ConsumerStatefulWidget {
  const AddMealScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddMealScreenState();
}

class _AddMealScreenState extends ConsumerState<AddMealScreen> {
  final nameController = TextEditingController();
  final proteinController = TextEditingController();

  void saveMeal() {
    final name = nameController.text;
    final protein = double.tryParse(proteinController.text) ?? 0;

    if (name.isEmpty || protein <= 0) return;

    var id = const Uuid().v1();

    final meal = Meals(id: id, name: name, protein: protein);

    ref.read(mealProvider.notifier).addMeal(meal);

    Navigator.pop(context);
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Meal"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. TextField -> Meal name
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Meal Name",
                  hintText: "e.g. Chicken Breast",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),

              // 2. TextField -> Protein (number)
              TextField(
                controller: proteinController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Protein (g)",
                  hintText: "e.g. 30",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 32),

              // 3. Button -> "Save Meal"
              ElevatedButton(
                onPressed: saveMeal,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Save Meal",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
