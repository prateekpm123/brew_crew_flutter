// This is the service file which talks to the Firebase 

import 'package:brew_crew/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:brew_crew/models/user.dart';


class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Crreate  a user object based on a FirebaseUser
  User _userFromFirebaseUser(FirebaseUser user) {         // a private function '_userFromFirebaseuser', which is storing user-uid using the custom User class we made in user.dart file
    return user != null ? User(uid: user.uid) : null;
  }

  // auth change user stream
  Stream<User> get user {
    return _auth.onAuthStateChanged
    .map(_userFromFirebaseUser);
  }

  // sign in anon
  Future signInAnon() async {
    try {
      AuthResult result = await _auth.signInAnonymously(); // a firebase inbuilt function to sign in Anonymously
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign in with email and password
  Future signInWithEmailAndPassword(String email, String password ) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    }
    catch(e) {
      print('Error while creating new email and password is $e');
      return null;
    }
  }


  // register with email and password
  Future registerWithEmailAndPassword(String email, String password ) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;

      // CREATE A DOCUMENT FOR THE USER WITH THE uid
      await DatabaseService(uid: user.uid).updateUserData('0', 'new crew member',100);

      return _userFromFirebaseUser(user);
    }
    catch(e) {
      print('Error while creating new email and password is $e');
      return null;
    }
  }


  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    }
    catch (e) {
      print('Error for signing out is $e');
      return null;
    }
  }

}