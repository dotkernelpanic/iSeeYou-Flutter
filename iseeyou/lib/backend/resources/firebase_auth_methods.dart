import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:iseeyou/models/message_model.dart';
import 'package:iseeyou/models/user_model.dart';

import '../../utils/utils.dart';

class FirebaseAuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;

  GoogleUser gUser = GoogleUser();

  Future<User> getCurrentUser() async {
    User currentUser;
    currentUser = (await _auth.currentUser)!;
    return currentUser;
  }

  Future<User> signIn() async {
    GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser!.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    UserCredential result = await _auth.signInWithCredential(credential);
    User user = result.user!;

    return user;
  }

  Future<bool> authenticateUser(User user) async {
    QuerySnapshot result = await firestore
        .collection("users")
        .where("email", isEqualTo: user.email)
        .get();

    final List<DocumentSnapshot> docs = result.docs;

    return docs.length == 0 ? true : false;
  }

  Future<void> addUserDataToDB(User currentUser) async {
    String username = Utils.getUsername(currentUser.email!);

    GoogleUser user = GoogleUser(
      uid: currentUser.uid,
      name: currentUser.displayName!,
      email: currentUser.email!,
      imageUrl: currentUser.photoURL!,
      username: username,
    );

    firestore
        .collection("users")
        .doc(currentUser.uid)
        .set(user.toMap(user) as Map<String, dynamic>);
  }

  Future<void> signOut() async {
    await _googleSignIn.disconnect();
    await _googleSignIn.signOut();
    return await _auth.signOut();
  }

  Future<List<GoogleUser>> fetchAllUsers(User currentUser) async {
    List<GoogleUser> userList = <GoogleUser>[];

    QuerySnapshot querySnapshot = await firestore.collection("users").get();

    for (var i = 0; i < querySnapshot.docs.length; i++) {
      if (querySnapshot.docs[i].id != currentUser.uid) {
        userList.add(GoogleUser.fromMap(
            querySnapshot.docs[i].data() as Map<String, dynamic>));
        print(querySnapshot.docs[i].data());
      }
    }
    for (var i = 0; i < userList.length; i++) {
      print(
          "${userList[i].name} + ${userList[i].uid} + ${userList[i].email} + ${userList[i].imageUrl} + ${userList[i].username}");
    }
    return userList;
  }

  Future<DocumentReference<Map<String, dynamic>>> addMessageToDb(
      Message message, GoogleUser sender, GoogleUser receiver) async {
    var map = message.toMap();

    await firestore
        .collection("messages")
        .doc(message.senderID)
        .collection(message.receiverID!)
        .add(map as Map<String, dynamic>);

    return await firestore
        .collection("messages")
        .doc(message.receiverID)
        .collection(message.senderID!)
        .add(map);
  }
}
