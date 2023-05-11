
import 'package:chat_app/application_layer/shared_preferences/shared_preferences.dart';

class AppStrings{
  static String uId=CashHelper.getStringData(key: 'uId').toString();
  static String phone=CashHelper.getStringData(key: 'phone').toString();
  static String countryCode=CashHelper.getStringData(key: 'countryCode').toString();
  static const String splashTitle='Connect. Chat. Unwind.';
  static const String splashSubTitle='Chatting has never been easier! Join our app and enjoy seamless communication with your loved ones';
  static const String phoneNumberTitle='What is your phone number ?';
  static const String phoneNumberSubTitle='Please enter your phone number to verify your account.';
  static const String otpTitle='Verify your phone number';
  static const String otpSubTitle='Enter your 6 digit code numbers sent to you at ';
  static const String doNotReceive='don\'t receive a verification code ? ';







}
