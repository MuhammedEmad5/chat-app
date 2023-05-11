import 'package:flutter/material.dart';

import '../../application_layer/constants/app_colors.dart';

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> defaultSnackBar(context,String error){
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
          error,
      ),
      backgroundColor: AppColors.firstColor.withOpacity(0.5),
      duration: const Duration(seconds: 4),
    ),
  );
}