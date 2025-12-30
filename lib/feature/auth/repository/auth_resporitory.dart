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
  User? user = FirebaseAuth.instance.currentUser;
  late UserModel _userModel;

  FutureEither<UserModel> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return right(UserModel(uid: _firebaseAuth.currentUser!.uid));
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  FutureEither<UserModel> signUpWithEmailAndPassword(
    String email,
    String username,
    String password,
  ) async {
    try {
      _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((userCredential) async {
            if (userCredential.additionalUserInfo!.isNewUser) {
              UserModel _userModel = UserModel(
                uid: _firebaseAuth.currentUser!.uid,
                username: username,
              );
              await _users
                  .doc(_firebaseAuth.currentUser!.uid)
                  .set(_userModel.toJson());
            } else {
              _userModel = await getUserData(userCredential.user!.uid).first;
            }
          });
      return right(UserModel(uid: _firebaseAuth.currentUser!.uid));
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Stream<UserModel> getUserData(uid) {
    return _users
        .doc(uid)
        .snapshots()
        .map(
          (event) => UserModel.fromJson(event.data() as Map<String, dynamic>),
        );
  }

  Either<dynamic, Future<void>> updateUserData(UserModel user) {
    final userId = _firebaseAuth.currentUser!.uid;

    try {
      return right(_users.doc(userId).update(user.toJson()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }
}
