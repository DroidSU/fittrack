import 'dart:async';

import 'package:fittrack/core/providers/firebase_providers.dart';
import 'package:fittrack/features/auth/providers/auth_provider.dart';
import 'package:fittrack/features/profile/models/user_profile.dart';
import 'package:fittrack/features/profile/repositories/profile_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepository(ref.watch(firestoreProvider));
});

class ProfileNotifier extends AsyncNotifier<UserProfile?> {
  @override
  FutureOr<UserProfile?> build() async {
    final user = ref.watch(authStateProvider).value;
    if (user == null) return null;
    return ref.watch(profileRepositoryProvider).getProfile(user.uid);
  }

  Future<void> updateProfile(UserProfile profile) async {
    final user = ref.watch(authStateProvider).value;
    if (user == null) return;

    state = const AsyncLoading();
    try {
      await ref.read(profileRepositoryProvider).saveProfile(user.uid, profile);
      state = AsyncData(profile);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}

final profileNotifierProvider = AsyncNotifierProvider<ProfileNotifier, UserProfile?>(ProfileNotifier.new);
