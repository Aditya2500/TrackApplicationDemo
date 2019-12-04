import 'dart:convert';
import 'dart:developer';
import 'package:firebase_database/firebase_database.dart';
import 'package:trackapp/services/session.dart';

class UserFirebase {
  final databaseReference = FirebaseDatabase.instance.reference();
  Future<bool> createUserInfo(
      String firstName,
      String lastName,
      String email,
      String phoneNumber,
      String dateOfBirth,
      String gender,
      String password,
      String uid) async {
    try {
      await databaseReference.child('loggedUsers').child(uid).set({
        'firstName': firstName,
        'lastName': lastName,
        'phoneNumber': phoneNumber,
        'gender': gender,
        'dateOfBirth': dateOfBirth,
        'email': email,
        'password': password,
        'uid': uid
      });
      Session.setStringList('loggedUsers',
          [firstName, lastName, email, phoneNumber, gender, uid, dateOfBirth]);
      return true;
    } catch (e) {
      log('UserFirebase.createUserInfo' + e.toString());
      return false;
    }
  }

  Future<bool> createUserInfoGoogle(
      String email, String uid, String displayName, String photoUrl) async {
    try {
      String child = email.replaceAll('@', '').replaceAll('.', '');
      await databaseReference
          .child('loggedUsers')
          .child(child)
          .set({'email': email, 'displayName': displayName, 'uid': uid});
      Session.setStringList('loggedUsers', [email, displayName, uid, photoUrl]);
      return true;
    } catch (e) {
      log('UserFirebase.createUserInfo' + e.toString());
      return false;
    }
  }

  Future<bool> updateUserInfo(
      String firstName,
      String lastName,
      String email,
      String phoneNumber,
      String dateOfBirth,
      String gender,
      String password,
      String uid) async {
    try {
      String displayName = firstName + ' ' + lastName;
      String child = email.replaceAll('@', '').replaceAll('.', '');
      await databaseReference.child('loggedUsers').child(child).set({
        'firstName': firstName,
        'lastName': lastName,
        'phoneNumber': phoneNumber,
        'gender': gender,
        'dateOfBirth': dateOfBirth,
        'email': email,
        'password': password,
        'displayName': displayName,
        'uid': uid
      });
      Session.setStringList('loggedUsers',
          [firstName, lastName, email, phoneNumber, gender, uid, dateOfBirth]);
      return true;
    } catch (e) {
      log('UserFirebase.createUserInfo' + e.toString());
      return false;
    }
  }

  Future<String> getUsers(String email) async {
    try {
      var users = {};
      String child = email.replaceAll('@', '').replaceAll('.', '');
      await databaseReference
          .child("loggedUsers")
          .child(child)
          .once()
          .then((DataSnapshot snapshot) {
        Map<dynamic, dynamic> values = snapshot.value;
        users = values;
      });
      return jsonEncode(users);
    } catch (e) {
      log('UserFirebase.isUserExists' + e.toString());
      return 'false';
    }
  }

  Future<bool> isUserExists(String email) async {
    try {
      String useremail = '';
      String child = email.replaceAll('@', '').replaceAll('.', '');
      await databaseReference
          .child("loggedUsers")
          .child(child)
          .once()
          .then((DataSnapshot snapshot) {
        Map<dynamic, dynamic> values = snapshot.value;
        useremail = values['email'];
      });
      if (useremail == email) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      log('UserFirebase.isUserExists' + e.toString());
      return false;
    }
  }
}
