import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intern_assignment/resources/storage_methods.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // sign up user

  Future<String> signUpUser({
    required String email,
    required String password,
    required String name,
    required String userType,
    required String number,
    required String year,
    required Uint8List file,
  }) async {
    String res = "Some Error occured";

    try {
      if (email.isNotEmpty ||
          name.isNotEmpty ||
          password.isNotEmpty ||
          userType.isNotEmpty ||
          year.isNotEmpty ||
          number.isNotEmpty ||
          file != null) {
        // register user

        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        print(':::::::>>>>' + cred.user!.uid);

        String photoUrl =
            await StorageMethods().uploadImageToStorage('profilePics', file);

        // add user to our database

        await _firestore.collection('users').doc(cred.user!.uid).set({
          'Name': name,
          'uid': cred.user!.uid,
          'email': email,
          'User Type': userType,
          'year': year,
          'Number': number,
          'photoUrl': photoUrl,
        });

        res =
            ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>::::::::::::::::::::::::::::::: Success";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> loginUser(
      {required String email, required String password}) async {
    String res = "Some error occurred";

    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = "Success";
      } else {
        res = "Please Enter All Fields";
      }
    } catch (err) {
      res = err.toString();
    }

    return res;
  }

  Future<void> signout() async {
    await _auth.signOut();
  }
}
