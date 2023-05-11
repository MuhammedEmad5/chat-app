import 'package:chat_app/application_layer/shared_preferences/shared_preferences.dart';
import 'package:chat_app/application_layer/themes.dart';
import 'package:chat_app/presentation_layer/screens/home_layout/home_Layout.dart';
import 'package:chat_app/presentation_layer/screens/home_layout/home_cubit/cubit.dart';
import 'package:chat_app/presentation_layer/screens/my_friends_chats/my_friends_chats_cubit/cubit.dart';
import 'package:chat_app/presentation_layer/screens/my_profile/my_profile_cubit/cubit.dart';
import 'package:chat_app/presentation_layer/screens/no_internet_Screen.dart';
import 'package:chat_app/presentation_layer/screens/phone_register/phone_verification_screen.dart';
import 'package:chat_app/presentation_layer/screens/splash_screen/splash_screen.dart';
import 'package:chat_app/presentation_layer/widgets/loading.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'application_layer/bloc_observer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  Bloc.observer = MyBlocObserver();
  await CashHelper.init();

  bool splashView = CashHelper.getBoolData(key: 'splash') ?? false;
  bool login = CashHelper.getBoolData(key: 'login') ?? false;

  final Widget startScreen;
  if (splashView) {
    if (login) {
      startScreen = const HomeScreen();
    } else {
      startScreen = PhoneVerificationScreen();
    }
  } else {
    startScreen = const SplashView();
  }
  runApp(MyApp(startScreen));
}

class MyApp extends StatefulWidget {
  const MyApp(this.startScreen, {super.key});

  final Widget startScreen;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Stream<bool>? _internetStream;

  @override
  void initState() {
    super.initState();
    //check internet before open app
    _internetStream = Connectivity().onConnectivityChanged.map((result) {
      return result != ConnectivityResult.none;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (BuildContext context) => HomeCubit()),
        BlocProvider(
            create: (BuildContext context) =>
                MyFriendsChatsCubit()..getMyFriendsChats()),
        BlocProvider(
            create: (BuildContext context) => MyProfileCubit()..getUserData()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (BuildContext context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: lightTheme(),
            home: StreamBuilder<bool>(
              stream: _internetStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  bool isConnected = snapshot.data!;
                  return !isConnected
                      ? const NoInternetScreen()
                      : StreamBuilder<ConnectivityResult>(
                          stream: Connectivity().onConnectivityChanged,
                          builder: (BuildContext context,
                              AsyncSnapshot<dynamic> snapshot) {
                            return snapshot.data == ConnectivityResult.none
                                ? const NoInternetScreen()
                                : widget.startScreen;
                          },
                        ); //check internet during use app
                } else {
                  return const Center(child: AppLoading());
                }
              },
            ),
          );
        },
      ),
    );
  }
}
