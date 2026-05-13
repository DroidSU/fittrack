import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fittrack/features/meals/models/meals.dart';
import 'package:hive/hive.dart';

class MealsRepository {
  final FirebaseFirestore _firestore;
  final Box _box;
  final String _userId;

  MealsRepository(this._firestore, this._box, this._userId);

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('users').doc(_userId).collection('meals');

  Future<List<Meals>> getMeals() async {
    try {
      final snapshot = await _collection.orderBy('createdAt', descending: true).get();
      final meals = snapshot.docs.map((doc) => Meals.fromJson(doc.data())).toList();
      
      // Update local cache
      await _box.put('meals', meals.map((m) => m.toJson()).toList());
      
      return meals;
    } catch (e) {
      // Fallback to local cache
      final localData = _box.get('meals', defaultValue: []) as List;
      return localData.map((item) => Meals.fromJson(Map<String, dynamic>.from(item))).toList();
    }
  }

  Future<void> addMeal(Meals meal) async {
    // Add to Firestore
    await _collection.doc(meal.id).set(meal.toJson());
    
    // Update local cache
    final meals = await getMeals();
    if (!meals.any((m) => m.id == meal.id)) {
      final updatedMeals = [meal, ...meals];
      await _box.put('meals', updatedMeals.map((m) => m.toJson()).toList());
    }
  }

  Future<void> deleteMeal(String mealId) async {
    await _collection.doc(mealId).delete();
    
    final localData = _box.get('meals', defaultValue: []) as List;
    final updatedData = localData.where((item) => item['id'] != mealId).toList();
    await _box.put('meals', updatedData);
  }
}
