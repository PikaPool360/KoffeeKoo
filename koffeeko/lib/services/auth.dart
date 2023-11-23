import 'package:google_sign_in/google_sign_in.dart';
import 'package:koffeeko/models/user.dart';
import 'package:koffeeko/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _googleSignIn = GoogleSignIn();

  // Create a user obj based on FirebaseUser
  UserIn? _userFromFirebaseUser(User? user) {
    return user != null ? UserIn(uid: user.uid) : null;
  }

  // auth chnage user stream
  Stream<User?> get user {
    return _auth.authStateChanges();
    // user.map((User? user) => _userFromFirebaseUser(user));
    // ignore: dead_code
    user.map(_userFromFirebaseUser);
  }

  // sign in anon
  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      //print(e.toString());
      return null;
    }
  }

  // sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      //print(e.toString());
      return null;
    }
  }

  // register with email and password
  Future reegisterWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;

      // Create a new document for the user with the uid
      await DatabaseService(uid: user!.uid)
          .updateUserData('0', 'New Crew Member', 100);

      return _userFromFirebaseUser(user);
    } catch (e) {
      //print(e.toString());
      return null;
    }
  }

  // register with Google Sign In
  signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final AuthCredential authCredential = GoogleAuthProvider.credential(
            accessToken: googleSignInAuthentication.accessToken,
            idToken: googleSignInAuthentication.idToken);
        UserCredential result =
            await _auth.signInWithCredential(authCredential);

        User? user = result.user;

        // Create a new document for the user with the uid
        await DatabaseService(uid: user!.uid)
            .updateUserData('0', 'New Crew Member', 100);

        return _userFromFirebaseUser(user);
      }
    } on FirebaseAuthException catch (e) {
      print(e.message);
      throw e;
    }
  }

  // login with Google Sign In
  loginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final AuthCredential authCredential = GoogleAuthProvider.credential(
            accessToken: googleSignInAuthentication.accessToken,
            idToken: googleSignInAuthentication.idToken);
        UserCredential result =
            await _auth.signInWithCredential(authCredential);

        User? user = result.user;
        return _userFromFirebaseUser(user);
      }
    } on FirebaseAuthException catch (e) {
      print(e.message);
      throw e;
    }
  }

  // sign out
  Future signOut() async {
    try {
      await _auth.signOut();
      await _googleSignIn.signOut();
    } catch (e) {
      //print(e.toString());
      return null;
    }
  }
}
