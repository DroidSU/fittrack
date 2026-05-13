import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fittrack/core/providers/firebase_providers.dart';
import 'package:fittrack/features/auth/repositories/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return FirebaseAuthRepository(ref.watch(firebaseAuthProvider));
});

final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
});

class AuthState {
  final User? user;
  final String? verificationId;
  final bool isLoading;
  final String? error;
  final bool codeSent;
  final String? phoneNumber;
  final bool isVerified;

  AuthState({
    this.user,
    this.verificationId,
    this.isLoading = false,
    this.error,
    this.codeSent = false,
    this.phoneNumber,
    this.isVerified = false,
  });

  AuthState copyWith({
    User? user,
    String? verificationId,
    bool? isLoading,
    String? error,
    bool? codeSent,
    String? phoneNumber,
    bool? isVerified,
  }) {
    return AuthState(
      user: user ?? this.user,
      verificationId: verificationId ?? this.verificationId,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      codeSent: codeSent ?? this.codeSent,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isVerified: isVerified ?? this.isVerified,
    );
  }
}

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    return AuthState(user: ref.watch(authRepositoryProvider).currentUser);
  }

  Future<void> sendOtp(String phoneNumber) async {
    state = state.copyWith(isLoading: true, error: null, phoneNumber: phoneNumber);
    
    try {
      await ref.read(authRepositoryProvider).verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          final result = await ref.read(authRepositoryProvider).signInWithCredential(credential);
          state = state.copyWith(user: result.user, isLoading: false, isVerified: true);
        },
        verificationFailed: (FirebaseAuthException e) {
          state = state.copyWith(isLoading: false, error: e.message);
        },
        codeSent: (String verificationId, int? resendToken) {
          state = state.copyWith(
            isLoading: false, 
            verificationId: verificationId, 
            codeSent: true
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          state = state.copyWith(verificationId: verificationId);
        },
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> verifyOtp(String smsCode) async {
    if (state.verificationId == null) return;
    
    state = state.copyWith(isLoading: true, error: null);
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: state.verificationId!,
        smsCode: smsCode,
      );
      final result = await ref.read(authRepositoryProvider).signInWithCredential(credential);
      state = state.copyWith(user: result.user, isLoading: false, isVerified: true);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: "Invalid verification code.");
    }
  }

  void resetError() {
    state = state.copyWith(error: null);
  }

  void resetVerification() {
    state = state.copyWith(isVerified: false);
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true);
    await ref.read(authRepositoryProvider).signOut();
    state = AuthState();
  }
}

final authNotifierProvider = NotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);
