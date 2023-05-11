

abstract class PhoneAuthStates{}

class PhoneAuthInitialState extends PhoneAuthStates{}


class PhoneAuthLoadingState extends PhoneAuthStates{}
class PhoneAuthSuccessState extends PhoneAuthStates{}
class PhoneAuthErrorState extends PhoneAuthStates{
  final String error;

  PhoneAuthErrorState(this.error);
}

class PhoneAuthSmsSentSuccessState extends PhoneAuthStates{}

class PhoneOtpVerifiedLoadingState extends PhoneAuthStates{}
class PhoneOtpVerifiedSuccessState extends PhoneAuthStates{
  final String uId;

  PhoneOtpVerifiedSuccessState(this.uId);
}


























