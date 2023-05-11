import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'constants/app_colors.dart';

ThemeData lightTheme() {
  return ThemeData(
    useMaterial3: true,
    fontFamily: 'ubuntu',
    primaryColor: AppColors.firstColor,
    primarySwatch: AppColors.myMaterialColor,
    appBarTheme: AppBarTheme(
      elevation: 0.0,
      titleTextStyle: TextStyle(
          fontSize: 20.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.white,
          fontFamily: 'ubuntu'),
      iconTheme: IconThemeData(color: AppColors.firstColor),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: AppColors.white,
        statusBarIconBrightness: Brightness.dark,
      ),
    ),
    textTheme: TextTheme(
      displayLarge: TextStyle(
          fontSize: 24.sp, fontWeight: FontWeight.w700, color: AppColors.black),
      displayMedium: TextStyle(
          fontSize: 22.sp, fontWeight: FontWeight.w500, color: AppColors.black),
      displaySmall: TextStyle(
          fontSize: 20.sp, fontWeight: FontWeight.w400, color: AppColors.black),
      headlineMedium: TextStyle(
          fontSize: 18.sp, fontWeight: FontWeight.w300, color: AppColors.black),
      headlineSmall: TextStyle(
          fontSize: 16.sp, fontWeight: FontWeight.w300, color: AppColors.black),
      titleLarge: TextStyle(
          fontSize: 14.sp, fontWeight: FontWeight.w300, color: AppColors.black),
      bodySmall: TextStyle(
          fontSize: 12.sp, fontWeight: FontWeight.w300, color: AppColors.black),
      labelSmall: TextStyle(
          fontSize: 10.sp, fontWeight: FontWeight.w200, color: AppColors.black),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.transparent,
      elevation: 0,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppColors.white,
      unselectedItemColor: Colors.black45,
      selectedIconTheme: const IconThemeData(
        size: 20,
      ),
      unselectedIconTheme: const IconThemeData(
        size: 20,
      ),
      selectedLabelStyle: TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.w600
      ),
    )
  );
}
