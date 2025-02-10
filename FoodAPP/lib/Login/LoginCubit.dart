import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';

import '../localStorage/StorageRepository.dart';

part 'LoginState.dart';

class LoginCubit extends Cubit<LoginState> {
  final StorageRepository storageRepository;
  LoginCubit(this.storageRepository) : super(LoginInitial());

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  void signInWithGoogle() async {
     emit(LoginProcessing());
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
         emit(LoginInitial());
         return;
      }
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      emit(LoginSuccess());
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(credential);
      storageRepository.setName(userCredential.user?.displayName?? '');
      storageRepository.setFirebaseUID(userCredential.user?.uid ?? '');
      storageRepository.setLoggedIn(true);
      emit(LoginSuccess());
    } catch (e) {
      emit(LoginFailed("Google Sign-In failed: $e"));
      return null;
    }
  }

  Future<void> verifyPhoneNumber() async {
    emit(LoginProcessing());
    await _auth.verifyPhoneNumber(
      phoneNumber: "+918089178861",
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        debugPrint("Verification Failed: ${e.message}");
      },
      codeSent: (String verificationId, int? resendToken) {
        debugPrint("Code send: ");
        emit(OTPSend(verificationId));
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  Future<void> signInWithOTP(String smsCode,String verificationId) async {
    emit(LoginProcessing());
    PhoneAuthCredential credential =
    PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCode);
    await _auth.signInWithCredential(credential);

    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        storageRepository.setName(user.phoneNumber?? '');
        storageRepository.setFirebaseUID(user.tenantId ?? '');
        storageRepository.setLoggedIn(true);
        emit(LoginSuccess());
      }
    });

  }


}

