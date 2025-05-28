
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
//
// class AuthServices {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   String? _verificationId; // To store verification ID for OTP verification
//
//   // Sign Up with email and password
//   Future<String> signUpUser({
//     required String email,
//     required String password,
//     required String name,
//     required String phoneNum,
//   }) async {
//     String res = "Some error occurred";
//     try {
//       UserCredential credential = await _auth.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//
//       await _firestore.collection("users").doc(credential.user!.uid).set({
//         'name': name,
//         'email': email,
//         'phone': phoneNum,
//         'uid': credential.user!.uid,
//       });
//
//       res = "Successfully Signed Up";
//     } catch (e) {
//       res = e.toString();
//     }
//     return res;
//   }
//
//   // Login with email and password
//   Future<String> loginUser({
//     required String email,
//     required String password,
//   }) async {
//     String res = "Some error occurred";
//     try {
//       await _auth.signInWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//       res = "Successfully Logged In";
//     } catch (e) {
//       res = e.toString();
//     }
//     return res;
//   }
// // Request OTP for Phone Authentication
//   Future<String> requestOTP({required String phoneNumber}) async {
//     String res = "Some error occurred";
//     try {
//       await _auth.verifyPhoneNumber(
//         phoneNumber: phoneNumber,
//         verificationCompleted: (PhoneAuthCredential credential) async {
//           await _auth.signInWithCredential(credential);
//           res = "Successfully Logged In via Phone";
//         },
//         verificationFailed: (FirebaseAuthException e) {
//           res = e.message ?? "Verification failed";
//         },
//         codeSent: (String verificationId, int? resendToken) {
//           _verificationId = verificationId;
//           res = "OTP Sent";
//         },
//         codeAutoRetrievalTimeout:(String verificationId) {
//           _verificationId = verificationId;
//         },
//       );
//     } catch (e) {
//       res = e.toString();
//     }
//     return res;
//   }
//
// // Verify OTP and Sign in
//   Future<String> verifyOTP({required String otp}) async {
//     String res = "Some error occurred";
//     try {
//       if (_verificationId != null) {
//         PhoneAuthCredential credential = PhoneAuthProvider.credential(
//           verificationId:_verificationId!,
//           smsCode : otp,
//         );
//
//         await _auth.signInWithCredential(credential);
//
//         res ="Successfully Logged In via Phone";
//       } else{
//         res ="Verification ID not found";
//       }
//     } catch(e){
//       res= e.toString();
//     }
//     return res;
//   }
//
//   // Logout function
//   Future<void> signOut() async {
//     try {
//       await _auth.signOut();
//       print("User signed out successfully");
//     } catch (e) {
//       print("Error signing out: $e");
//     }
//   }
// }




import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _verificationId; // To store verification ID for OTP verification

  // Sign Up with email and password
  Future<String> signUpUser({
    required String email,
    required String password,
    required String name,
    required String phoneNum,
  }) async {
    String res = "Some error occurred";
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _firestore.collection("users").doc(credential.user!.uid).set({
        'name': name,
        'email': email,
        'phone': phoneNum,
        'uid': credential.user!.uid,
      });

      res = "Successfully Signed Up";
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  // Login with email and password
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error occurred";
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Remove the call to saveLoginState
      res = "Successfully Logged In";
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

// Request OTP for Phone Authentication
  Future<String> requestOTP({required String phoneNumber}) async {
    String res = "Some error occurred";
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
          res = "Successfully Logged In via Phone";
        },
        verificationFailed: (FirebaseAuthException e) {
          res = e.message ?? "Verification failed";
        },
        codeSent: (String verificationId, int? resendToken) {
          _verificationId = verificationId;
          res = "OTP Sent";
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
        },
      );
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

// Verify OTP and Sign in
  Future<String> verifyOTP({required String otp}) async {
    String res = "Some error occurred";
    try {
      if (_verificationId != null) {
        PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: _verificationId!,
          smsCode: otp,
        );

        await _auth.signInWithCredential(credential);

        res = "Successfully Logged In via Phone";
      } else {
        res = "Verification ID not found";
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  // Logout function
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      print("User signed out successfully");
    } catch (e) {
      print("Error signing out: $e");
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

// Remove the saveLoginState and getLoginState methods
}
