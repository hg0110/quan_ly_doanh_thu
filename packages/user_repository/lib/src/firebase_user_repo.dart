import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../user_repository.dart';

class FirebaseUserRepo implements UserRepository {
  final FirebaseAuth _firebaseAuth;

  final usersCollection = FirebaseFirestore.instance.collection('users');

  FirebaseUserRepo({
    FirebaseAuth? firebaseAuth,
  }) : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  @override
  Stream<User?> get user {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      return firebaseUser;
    });
  }

  @override
  Future<void> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      // Get user ID
      String userId = userCredential.user!.uid;

      // Get user document from Firestore
      DocumentSnapshot userDoc = await usersCollection.doc(userId).get();

      // Check if the user document exists and has a 'role' field
      if (userDoc.exists && userDoc.data() != null) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        String roles = userData['roles'];

        // Check if the role is 'admin'
        if (roles == 'admin') {
          // Admin login successful
          return;
        } else {
          // Not an admin, throw an exception or handle accordingly
          // return;
          throw Exception('Chỉ có quản trị viên mới được phép đăng nhập.');
        }
      } else {
        // User document not found or missing 'role' field
        throw Exception(
            'Không tìm thấy dữ liệu người dùng hoặc dữ liệu không hợp lệ.');
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<MyUser> signUp(MyUser myUser, String password) async {
    try {
      UserCredential user = await _firebaseAuth.createUserWithEmailAndPassword(
          email: myUser.email, password: password);

      myUser = myUser.copyWith(userId: user.user!.uid);

      return myUser;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> setUserData(MyUser myUser) async {
    try {
      await usersCollection
          .doc(myUser.userId)
          .set(myUser.toEntity().toDocument());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> logOut() async {
    await _firebaseAuth.signOut();
  }

  @override
  Future<List<MyUser>> getMyUser() async {
    try {
      return await usersCollection.get().then((value) => value.docs
          .map((e) => MyUser.fromEntity(MyUserEntity.fromDocument(e.data())))
          .toList());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<MyUser?> deleteUser(String userId) async {
    try {
      final doc = await usersCollection.doc(userId).get();
      if (doc.exists) {
        final user = MyUser.fromEntity(MyUserEntity.fromDocument(doc.data()!));
        await doc.reference.delete();
        return user;
      } else {
        return null; // Driver not found
      }
    } catch (e) {
      log(e.toString());
      return null; // Deletion failed
    }
  }

//
// @override
// Future<MyUser> getUser(String userId) async {
// 	try {
// 		return usersCollection.doc(userId).get().then((value) =>
// 				MyUser.fromEntity(MyUserEntity.fromDocument(value.data()!))
// 		);
// 	} catch (e) {
// 		log(e.toString());
// 		rethrow;
// 	}
// }
}
