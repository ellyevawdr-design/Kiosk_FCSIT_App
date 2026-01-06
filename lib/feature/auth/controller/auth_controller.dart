import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:networkclan_kiosk_fcsit_app/feature/auth/model/user_model.dart';
import 'package:networkclan_kiosk_fcsit_app/feature/auth/repository/auth_resporitory.dart';

final authControllerProvider = AsyncNotifierProvider<AuthController, void>(
  AuthController.new,
);

final authStateChangeProvider = StreamProvider((ref) {
  return ref.watch(authControllerProvider.notifier).authStateChange;
});

final userProvider = StateProvider<UserModel?>((ref) => null);

class AuthController extends AsyncNotifier<void> {
  late AuthRepository _authRepository;

  @override
  void build() {
    _authRepository = ref.watch(authRepositoryProvider);
  }

  Stream<User?> get authStateChange => _authRepository.authStateChange;

  /// ---------------- GET USER DATA ----------------
  Stream<UserModel> getUserData(String uid) {
    return _authRepository.getUserData(uid);
  }

  /// ---------------- UPDATE USERNAME ----------------
  Future<void> updateUsername(BuildContext context, String username) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("User not logged in")));
      return;
    }

    final updatedUser = UserModel(
      uid: user.uid,
      username: username,
      profileImage: ref.read(userProvider)?.profileImage,
      email: ref.read(userProvider)?.email,
    );

    try {
      // Update locally first
      ref.read(userProvider.notifier).update((state) => updatedUser);

      // Then update Firestore
      final res = await _authRepository.updateUserData(updatedUser);
      res.fold(
        (failure) {
          if (!context.mounted) return;
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Failed: ${failure.message}")));
        },
        (_) {
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Username updated successfully")),
          );
        },
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating username: ${e.toString()}")),
      );
    }
  }

  /// ---------------- RE-AUTHENTICATE USER ----------------
  Future<bool> reauthenticate(
    BuildContext context,
    String currentPassword,
  ) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        if (!context.mounted) return false;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("User not logged in")));
        return false;
      }

      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );

      await user.reauthenticateWithCredential(credential);
      return true;
    } on FirebaseAuthException catch (e) {
      if (!context.mounted) return false;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? "Re-authentication failed")),
      );
      return false;
    }
  }

  /// ---------------- UPDATE PASSWORD ----------------
  Future<void> updatePassword(
    BuildContext context,
    String currentPassword,
    String newPassword,
  ) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    // Re-authenticate
    final success = await reauthenticate(context, currentPassword);
    if (!success) return;

    try {
      await user.updatePassword(newPassword);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password updated successfully")),
      );
    } on FirebaseAuthException catch (e) {
      final message = e.message ?? "Password update failed";
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  /// ---------------- SIGN IN ----------------
  Future<void> signInWithEmailAndPassword(
    String email,
    String password,
    BuildContext context,
  ) async {
    state = const AsyncLoading();

    try {
      final res = await _authRepository.signInWithEmailAndPassword(
        email,
        password,
      );

      res.fold(
        (failure) {
          state = AsyncError(failure, StackTrace.current);
          if (!context.mounted) return;
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(failure.message)));
        },
        (userModel) {
          // Update local userProvider
          ref.read(userProvider.notifier).state = userModel;
          state = const AsyncData(null);

          if (!context.mounted) return;
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text("Login successful")));
        },
      );
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Login failed: ${e.toString()}")));
    }
  }

  /// ---------------- SIGN UP ----------------
  Future<void> signUpWithEmailAndPassword(
    String email,
    String password,
    String username,
    BuildContext context,
  ) async {
    state = const AsyncLoading();

    try {
      final res = await _authRepository.signUpWithEmailAndPassword(
        email,
        password,
      );

      res.fold(
        (failure) {
          state = AsyncError(failure, StackTrace.current);
          if (!context.mounted) return;
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(failure.message)));
        },
        (userModel) async {
          // Update username locally
          final updatedUser = userModel.copyWith(
            username: username,
            email: email,
          );
          ref.read(userProvider.notifier).state = updatedUser;

          // Update Firestore
          if (username.isNotEmpty) {
            await _authRepository.updateUserData(updatedUser);
          }

          state = const AsyncData(null);
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Account created successfully")),
          );
        },
      );
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Sign-up failed: ${e.toString()}")),
      );
    }
  }

  /// ---------------- SIGN OUT ----------------
  Future<void> signOut() async {
    await _authRepository.signOut();
    ref.read(userProvider.notifier).state = null;
  }
}
