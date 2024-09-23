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
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<String> getRole(String userId) async {
    try {
      // 1. Get a reference to the user's document in Firestore
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      // 2. Check if the document exists and contains data
      if (userDoc.exists && userDoc.data() != null) {
        // 3. Cast the document data to a Map
        final userData = userDoc.data() as Map<String, dynamic>;

        // 4. Retrieve the 'role' field
        final role = userData['roles'] as String;

        // 5. Return the role
        return role;
      } else {
        // Handle the case where the user document doesn't exist or has no data
        return 'unknown'; // Or throw an exception
      }
    } catch (e) {
      // Handle any errors that occur during the process
      print('Error getting role: $e');
      return 'unknown'; // Or throw an exception
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
  Future<List<MyUser>> getUser() async {
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
  Future<MyUser> getMyUser(String myUserId) async {
    try {
      return usersCollection.doc(myUserId).get().then((value) =>
          MyUser.fromEntity(MyUserEntity.fromDocument(value.data()!)));
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<MyUser?> getUserByEmail(String email) async {
    try {
      final querySnapshot =
          await usersCollection.where('email', isEqualTo: email).get();
      if (querySnapshot.docs.isNotEmpty) {
        return MyUser.fromEntity(
            MyUserEntity.fromDocument(querySnapshot.docs.first.data()));
      } else {
        return null;
      }
    } catch (e) {
      // Handle potential errors (e.g., database connection errors)
      print('Error getting driver by email: $e');
      return null;
    }
  }

  @override
  Future<List<MyUser>> searchUserByEmail(String email) async {
    try {
      final querySnapshot =
      await usersCollection.where('email', isEqualTo: email).get();
      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs
            .map((e) => MyUser.fromEntity(MyUserEntity.fromDocument(e.data())))
            .toList();
      } else {
        return [];
      }
    } catch (e) {
      print('Error searching user by email: $e');
      return [];
    }
  }

  @override
  Future<void> updateUser(MyUser user) async {
    try {
      await usersCollection
          .doc(user.userId)
          .update(user.toEntity().toDocument());
      return;
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
}
