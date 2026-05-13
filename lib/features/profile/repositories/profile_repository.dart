import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fittrack/features/profile/models/user_profile.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ProfileRepository {
  final FirebaseFirestore _firestore;
  static const String _profileBoxName = 'profileBox';

  ProfileRepository(this._firestore);

  Future<void> saveProfile(String uid, UserProfile profile) async {
    // 1. Save to Hive immediately (Offline-first)
    final box = await Hive.openBox(_profileBoxName);
    await box.put(uid, profile.toMap());

    // 2. Save to Firestore (Sync in background)
    try {
      await _firestore.collection('users').doc(uid).set({
        'profile': profile.toMap(),
      }, SetOptions(merge: true));
    } catch (e) {
      // If Firestore fails (e.g., offline), the data is already in Hive.
      // Firestore SDK will also automatically queue the write for when connection returns.
      print('Firestore sync failed, but data is saved locally: $e');
    }
  }

  Future<UserProfile?> getProfile(String uid) async {
    // 1. Try Hive first (Instant load)
    final box = await Hive.openBox(_profileBoxName);
    final localData = box.get(uid);
    
    if (localData != null) {
      return UserProfile.fromMap(Map<String, dynamic>.from(localData));
    }

    // 2. Fallback to Firestore if Hive is empty (e.g., new device)
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists && doc.data()?['profile'] != null) {
        final profileData = doc.data()?['profile'];
        final profile = UserProfile.fromMap(Map<String, dynamic>.from(profileData));
        
        // Sync back to local for future offline use
        await box.put(uid, profile.toMap());
        return profile;
      }
    } catch (e) {
      print('Firestore fetch failed: $e');
    }

    return null;
  }
}
