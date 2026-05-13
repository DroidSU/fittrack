import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fittrack/features/workouts/models/workout.dart';
import 'package:hive/hive.dart';

class WorkoutsRepository {
  final FirebaseFirestore _firestore;
  final Box _box;
  final String _userId;

  WorkoutsRepository(this._firestore, this._box, this._userId);

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('users').doc(_userId).collection('workouts');

  Future<List<Workout>> getWorkouts() async {
    try {
      final snapshot = await _collection.orderBy('createdAt', descending: true).get();
      final workouts = snapshot.docs.map((doc) => Workout.fromJson(doc.data())).toList();
      
      // Update local cache
      await _box.put('workouts', workouts.map((w) => w.toJson()).toList());
      
      return workouts;
    } catch (e) {
      // Fallback to local cache
      final localData = _box.get('workouts', defaultValue: []) as List;
      return localData.map((item) => Workout.fromJson(Map<String, dynamic>.from(item))).toList();
    }
  }

  Future<void> addWorkout(Workout workout) async {
    await _collection.doc(workout.id).set(workout.toJson());
    
    final workouts = await getWorkouts();
    if (!workouts.any((w) => w.id == workout.id)) {
      final updatedWorkouts = [workout, ...workouts];
      await _box.put('workouts', updatedWorkouts.map((w) => w.toJson()).toList());
    }
  }

  Future<void> deleteWorkout(String workoutId) async {
    await _collection.doc(workoutId).delete();
    
    final localData = _box.get('workouts', defaultValue: []) as List;
    final updatedData = localData.where((item) => item['id'] != workoutId).toList();
    await _box.put('workouts', updatedData);
  }
}
