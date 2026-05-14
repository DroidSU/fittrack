import 'dart:async';
import 'dart:io';

import 'package:fittrack/core/providers/firebase_providers.dart';
import 'package:fittrack/features/auth/providers/auth_provider.dart';
import 'package:fittrack/features/profile/models/user_profile.dart';
import 'package:fittrack/features/profile/repositories/profile_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

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
    final user = ref.read(authStateProvider).value;
    if (user == null) return;

    state = const AsyncLoading();
    try {
      await ref.read(profileRepositoryProvider).saveProfile(user.uid, profile);
      state = AsyncData(profile);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> uploadProfileImage() async {
    final user = ref.read(authStateProvider).value;
    if (user == null || state.value == null) return;

    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );

    if (image != null) {
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = 'profile_${user.uid}${p.extension(image.path)}';
      final savedImagePath = p.join(appDir.path, fileName);
      final savedImage = await File(image.path).copy(savedImagePath);

      final updatedProfile = state.value!.copyWith(profileImageUrl: savedImage.path);
      await updateProfile(updatedProfile);
    }
  }
}

final profileNotifierProvider = AsyncNotifierProvider<ProfileNotifier, UserProfile?>(ProfileNotifier.new);
