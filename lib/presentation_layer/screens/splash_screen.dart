import 'dart:async';
import 'package:chat_app/application_layer/app_strings.dart';
import 'package:chat_app/presentation_layer/screens/phone_verification_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import '../../application_layer/app_colors.dart';
import '../../application_layer/shared_preferences/shared_preferences.dart';

class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  SplashViewState createState() => SplashViewState();
}

class SplashViewState extends State<SplashView> {
  Timer? _timer;

  _startDelay() {
    _timer = Timer(const Duration(seconds: 4), _goNext);
  }

  _goNext() async {
    CashHelper.putBoolData(key: 'splash', value: true);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) =>  PhoneVerificationScreen()));
  }

  AppBar appBar() {
    return AppBar(
      toolbarHeight: double.minPositive,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: AppColors.firstColor,
        statusBarIconBrightness: Brightness.light,
      ),
      elevation: 0.0,
    );
  }

  @override
  void initState() {
    super.initState();
    _startDelay();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.firstColor,
      appBar: appBar(),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Lottie.asset('assets/animation/splash_view.json'),
            ),
            Text(
                AppStrings.splashTitle,
              style: TextStyle(
                color: AppColors.white,
                fontSize: 24,
                fontWeight: FontWeight.w700,
                fontFamily: 'Ubuntu'
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              AppStrings.splashSubTitle,
              style: TextStyle(
                  color: AppColors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Ubuntu'
              ),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
