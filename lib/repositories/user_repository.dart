import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:send_note_app/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepository {
  final _prefs = SharedPreferences.getInstance();
  final _firebaseAuth = FirebaseAuth.instance;
  final CollectionReference userCollection =
      Firestore.instance.collection('users');

  Future<void> signIn({String email, String password}) async {
    final AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final FirebaseUser user = result.user;

    await userCollection
        .document(user.uid)
        .get()
        .then(
          (ds) => persistUser(
            uid: user.uid,
            email: user.email,
            fullName: ds.data['fullName'],
          ),
        )
        .catchError((e) => print(e.toString()));
  }

  Future<void> signUp({String fullName, String email, String password}) async {
    final AuthResult result =
        await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final FirebaseUser user = result.user;

    await userCollection.document(user.uid).setData({
      'uid': user.uid,
      'fullName': fullName,
      'friends': ['friend'],
    });

    await persistUser(uid: user.uid, email: user.email, fullName: fullName);
  }

  Future<void> signOut() async {
    final prefs = await _prefs;
    prefs.clear();
    return await _firebaseAuth.signOut();
  }

  Future<bool> isSignedIn() async {
    final currentUser = await _firebaseAuth.currentUser();
    return currentUser != null;
  }

  Future<User> getUser() async {
    final prefs = await _prefs;
    final userMap = json.decode(prefs.get('user'));
    return User.fromJson(userMap);
  }

  Future persistUser({String uid, String email, String fullName}) async {
    final prefs = await _prefs;

    final Map<String, String> user = {
      'uid': uid,
      'email': email,
      'fullName': fullName,
    };

    print(json.encode(user));

    prefs.setString('user', json.encode(user));
  }

  Future addFriend(String uid) async {
    final User currentUser = await getUser();
    List friends;
    await userCollection
        .document(currentUser.uid)
        .get()
        .then((ds) => friends = ds['friends'])
        .catchError((e) => print(e.toString()));

    friends.add(uid);

    userCollection.document(currentUser.uid).updateData({
      'fullName': currentUser.fullName,
      'friends': friends,
    });
  }

  Future getFriend() async {
    final User currentUser = await getUser();
    List friends = [];
    await userCollection
        .document(currentUser.uid)
        .get()
        .then((ds) => friends = ds['friends'])
        .catchError((e) => print(e.toString()));

    print(friends);

    return friends;
  }
}
