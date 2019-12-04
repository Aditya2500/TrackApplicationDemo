import 'package:firebase_auth/firebase_auth.dart';
import 'package:trackapp/services/session.dart';

Future<FirebaseUser> signUpWithEmailAndPassword(
    String email, String password) async {
  final AuthResult authResult = await FirebaseAuth.instance
      .createUserWithEmailAndPassword(email: email, password: password);
  final FirebaseUser user = authResult.user;
  assert(!user.isAnonymous);
  assert(await user.getIdToken() != null);

  final FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
  assert(user.uid == currentUser.uid);

  return user;
}

Future signInWithEmailAndPassword(String email, String password) async {
  final AuthResult authResult = await FirebaseAuth.instance
      .signInWithEmailAndPassword(email: email, password: password);
  final FirebaseUser user = authResult.user;
  assert(!user.isAnonymous);
  assert(await user.getIdToken() != null);

  final FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
  assert(user.uid == currentUser.uid);
 
 List<String> list = List<String>();
  list.add(user.email);
  list.add(user.uid);
 Session.setStringList('signInWithEmailAndPassword', list);
  print("User sign in");

  return user;
}

Future signOut() async {
  FirebaseAuth.instance.signOut();
  print("User Sign Out");
}
