import 'dart:ui';

import 'package:flutter/material.dart';

class AppColors{
 static Color firstColor=const Color(0xff6E00DD);
 static Color secondColor=const Color(0xffA826C7);
 static Color white=const Color(0xffFFFFFF);
 static Color black=const Color(0xff000000);


 static MaterialColor myMaterialColor = MaterialColor(firstColor.value, <int, Color>{
   50: firstColor.withOpacity(0.1),
   100: firstColor.withOpacity(0.2),
   200: firstColor.withOpacity(0.3),
   300: firstColor.withOpacity(0.4),
   400: firstColor.withOpacity(0.5),
   500: firstColor.withOpacity(0.6),
   600: firstColor.withOpacity(0.7),
   700: firstColor.withOpacity(0.8),
   800: firstColor.withOpacity(0.9),
   900: firstColor.withOpacity(1.0),
 }); // Converted Material color


}