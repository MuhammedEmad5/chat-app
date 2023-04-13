

abstract class PhoneAuthStates{}

class PhoneAuthInitialState extends PhoneAuthStates{}


class PhoneAuthLoadingState extends PhoneAuthStates{}
class PhoneAuthSuccessState extends PhoneAuthStates{}
class PhoneAuthErrorState extends PhoneAuthStates{
  final String error;

  PhoneAuthErrorState(this.error);
}

class PhoneAuthSmsSentSuccessState extends PhoneAuthStates{}

class PhoneOtpVerifiedSuccessState extends PhoneAuthStates{}

class PhoneTimeOutState extends PhoneAuthStates{
  final String error;

  PhoneTimeOutState(this.error);
}







// Future<void> signInWithPhoneNumber() async {
//   final AuthCredential credential = PhoneAuthProvider.credential(
//     verificationId: _verificationId,
//     smsCode: _codeController.text,
//   );
//
//   try {
//     await FirebaseAuth.instance.signInWithCredential(credential);
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text('Successfully signed in with phone number.'),
//       ),
//     );
//   } catch (e) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text('Failed to sign in with phone number: $e'),
//       ),
//     );
//   }
// }


















