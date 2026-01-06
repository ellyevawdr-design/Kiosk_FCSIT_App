import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import 'package:networkclan_kiosk_fcsit_app/core/failure.dart';
import 'package:networkclan_kiosk_fcsit_app/core/type_defs.dart';
import 'package:networkclan_kiosk_fcsit_app/feature/auth/model/user_model.dart';
import 'package:networkclan_kiosk_fcsit_app/providers/firebase_providers.dart';
import 'package:networkclan_kiosk_fcsit_app/utils/firebaseconstants.dart';

final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
    firestore: ref.watch(firebaseFireStoreProvider),
    firebaseauth: ref.watch(firebaseAuthProvider),
    firebaseStorage: ref.watch(firebaseStorageProvider),
  ),
);

class AuthRepository {
  final FirebaseFirestore _firebaseFirestore;
  final FirebaseAuth _firebaseAuth;
  final FirebaseStorage _firebaseStorage;

  AuthRepository({
    required FirebaseFirestore firestore,
    required FirebaseAuth firebaseauth,
    required FirebaseStorage firebaseStorage,
  }) : _firebaseFirestore = firestore,
       _firebaseAuth = firebaseauth,
       _firebaseStorage = firebaseStorage;

  CollectionReference get _users =>
      _firebaseFirestore.collection(Firebaseconstants.usersCollection);

  Stream<User?> get authStateChange => _firebaseAuth.authStateChanges();

  /// ---------------- SIGN IN ----------------
  FutureEither<UserModel> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credential.user!;
      final snapshot = await _users.doc(user.uid).get();

      if (snapshot.exists) {
        final userModel = UserModel.fromJson(
          snapshot.data() as Map<String, dynamic>,
        );
        return right(userModel);
      } else {
        return left(Failure(message: "User data not found"));
      }
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  /// ---------------- SIGN UP ----------------
  FutureEither<UserModel> signUpWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = UserModel(uid: userCredential.user!.uid, email: email);

      await _users.doc(user.uid).set(user.toJson());

      return right(user);
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  /// ---------------- SIGN OUT ----------------
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  /// ---------------- GET USER DATA ----------------
  Stream<UserModel> getUserData(String uid) {
    return _users
        .doc(uid)
        .snapshots()
        .map(
          (event) => UserModel.fromJson(event.data() as Map<String, dynamic>),
        );
  }

  /// ---------------- UPDATE USER ----------------
  FutureEither<void> updateUserData(UserModel user) async {
    try {
      final userId = _firebaseAuth.currentUser!.uid;
      await _users.doc(userId).update(user.toJson());
      return right(null);
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }
}
