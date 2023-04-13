import 'package:chat_app/business_logic_layer/phone_auth_cubit/states.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PhoneAuthCubit extends Cubit<PhoneAuthStates> {
  PhoneAuthCubit() : super(PhoneAuthInitialState());

  late String _verificationId;

  static PhoneAuthCubit get(context) => BlocProvider.of(context);

  FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> verifyPhoneNumber(String phoneNumber) async {
    emit(PhoneAuthLoadingState());
    await auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(seconds: 15),
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
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

  void codeSent(String verificationId, int? resendToken)async {

    _verificationId = verificationId;
    if (kDebugMode) {
      print('codeSent!!!!!!!!!!!!!!!!!!!!!!!!!!!!!$_verificationId');
    }
    emit(PhoneAuthSmsSentSuccessState());
  }

  void codeAutoRetrievalTimeout(String verificationId) {
    _verificationId = verificationId;
    if (kDebugMode) {
      print('time out');
    }
    emit(PhoneTimeOutState('time out'));
  }



  Future<void> submitOtp(String otpCode) async {
    final PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId, smsCode: otpCode);

    await signIn(credential);
  }

  Future<void> signIn(PhoneAuthCredential credential) async {
    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
      emit(PhoneOtpVerifiedSuccessState());
    } catch (error) {
      emit(PhoneAuthErrorState(error.toString()));
    }
  }




  Future<void> logOut() async {
    await FirebaseAuth.instance.signOut();
  }

  User getLoggedInUser() {
    User firebaseUser = FirebaseAuth.instance.currentUser!;
    return firebaseUser;
  }

// File? pickedImage;
// Future<void> pickBrestCancerImage() async {
//   final image =
//       await ImagePicker().pickImage(source: ImageSource.gallery);
//   if (image != null) {
//     pickedImage = File(image.path);
//     emit(PickImageSuccessState());
//   } else {
//     emit(PickImageErrorState());
//   }
// }
}
