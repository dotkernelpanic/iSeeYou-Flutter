import 'package:firebase_auth/firebase_auth.dart';
import 'package:iseeyou/backend/resources/firebase_auth_methods.dart';
import 'package:iseeyou/models/message_model.dart';

import '../../models/user_model.dart';

class FirebaseAuthRepository {
  FirebaseAuthMethods _firebaseAuthMethods = FirebaseAuthMethods();

  Future<User> getCurrentUser() => _firebaseAuthMethods.getCurrentUser();

  Future<User> signIn() => _firebaseAuthMethods.signIn();

  Future<bool> authenticateUser(User user) =>
      _firebaseAuthMethods.authenticateUser(user);

  Future<void> addUserDataToDB(User currentUser) =>
      _firebaseAuthMethods.addUserDataToDB(currentUser);

  Future<void> signOut() => _firebaseAuthMethods.signOut();

  Future<List<GoogleUser>> fetchAllUsers(User user) =>
      _firebaseAuthMethods.fetchAllUsers(user);

  Future<void> addMessageToDb(
          Message message, GoogleUser sender, GoogleUser receiver) =>
      _firebaseAuthMethods.addMessageToDb(message, sender, receiver);
}
