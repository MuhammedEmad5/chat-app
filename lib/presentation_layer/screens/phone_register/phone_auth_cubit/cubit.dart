import 'package:chat_app/presentation_layer/screens/phone_register/phone_auth_cubit/states.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../application_layer/shared_preferences/shared_preferences.dart';



class PhoneAuthCubit extends Cubit<PhoneAuthStates> {

  PhoneAuthCubit() : super(PhoneAuthInitialState());

  static PhoneAuthCubit get(context) => BlocProvider.of(context);

  FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> verifyPhoneNumber(String phoneNumber,{int? forceResendingToken}) async {
    emit(PhoneAuthLoadingState());
    await auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(seconds: 15),
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      forceResendingToken: forceResendingToken,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    );
  }

  void verificationCompleted(PhoneAuthCredential credential) async {
    if (kDebugMode) {
      print('verificationCompleted');
    }
    await signIn(credential);
  }

  void verificationFailed(FirebaseAuthException error) {
    if (error.code == 'invalid-phone-number') {
      if (kDebugMode) {
        print('The provided phone number is not valid.');
      }
    }
    // Handle other errors
    if (kDebugMode) {
      print('verificationFailed : ${error.toString()}');
    }
    emit(PhoneAuthErrorState(error.toString()));
  }

  void codeSent(String verificationId, [int? forceResendingToken])async {
    CashHelper.putStringData(key: 'verificationId', value: verificationId);
    CashHelper.putIntData(key: 'forceResendingToken', value: forceResendingToken!);
    emit(PhoneAuthSmsSentSuccessState());
  }

  void codeAutoRetrievalTimeout(String verificationId) {
    CashHelper.putStringData(key: 'verificationId', value: verificationId);
    if (kDebugMode) {
      print('time out');
    }
  }


  Future<void> submitOtp(String otpCode) async {
     PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: CashHelper.getStringData(key: 'verificationId')!,
         smsCode: otpCode,
     );

    await signIn(credential);
  }

  Future<void> signIn(PhoneAuthCredential credential) async {
    emit(PhoneOtpVerifiedLoadingState());
    try {
      await auth.signInWithCredential(credential).then((value) {
       // getLoggedInUser();
        emit(PhoneOtpVerifiedSuccessState(value.user!.uid));
      });
    } catch (error) {
      emit(PhoneAuthErrorState(error.toString()));
    }
  }

  void reSend(String phoneNumber,int forceResendingToken){
    verifyPhoneNumber(phoneNumber,forceResendingToken:forceResendingToken);
  }




}
