import 'package:bloc/bloc.dart';
import 'package:chat_app/application_layer/shared_preferences/shared_preferences.dart';
import 'package:chat_app/application_layer/themes.dart';
import 'package:chat_app/presentation_layer/screens/phone_verification_screen.dart';
import 'package:chat_app/presentation_layer/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'application_layer/bloc_observer.dart';


void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  Bloc.observer = MyBlocObserver();
  await CashHelper.init();

  bool splashView=CashHelper.getBoolData(key: 'splash')??false;

  final Widget startScreen;
  if(splashView){
    startScreen= PhoneVerificationScreen();
  }else {
    startScreen= const SplashView();
  }
  runApp( MyApp(startScreen));
}

class MyApp extends StatelessWidget {
  const MyApp(this.startScreen,{super.key, });
  final Widget startScreen;

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (BuildContext context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: lightTheme(),
            home: startScreen,
          );
        });



  }
}

