import 'package:firebase_auth/firebase_auth.dart';
import 'models/models.dart';

abstract class UserRepository {
	Stream<User?> get user;

	Future<MyUser> signUp(MyUser myUser, String password);

	Future<void> setUserData(MyUser user);

	Future<void> signIn(String email, String password);

	Future<String> getRole(String userId);

	Future<void> logOut();

	Future<List<MyUser>> getUser();

	Future<List<MyUser>> searchUserByEmail(String email);

	Future<MyUser> getMyUser(String myUserId);

	Future<MyUser?> getUserByEmail(String email);

	Future<void> updateUser(MyUser user);

	Future<void> deleteUser(String userId);

	// Future<String> uploadPicture(String file, String userId);

}