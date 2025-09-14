//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
/*class AuthService {
  final FirebaseAuth _auth= FirebaseAuth.instance;
  final FirebaseFirestore _firestore=FirebaseFirestore.instance;
  /*Future<UserCredential> signInWithEmailPassword(String email,password) async{
    try{
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email, 
        password: password
      );
      //save user info in a seperate doc
      _firestore.collection("Users").doc(userCredential.user!.uid).set(
        {
        'uid':userCredential.user!.uid,
        'email':email,
        },
      );
      return userCredential;
    }on FirebaseAuthException catch(e) {
      throw Exception(e.code);
    }
  }
}8*/*/
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  // Method to sign in with email and password
  Future<UserCredential> signInWithEmailPassword(String email, String password) async {
    try {
      // Sign in the user using Firebase Authentication
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code); // Return the error code if there is an issue
    }
  }
}
