import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../application_layer/app_colors.dart';


class DefaultButton extends StatelessWidget {
  const DefaultButton({Key? key, required this.widget, required this.onPressed,this.mini=false})
      : super(key: key);

  final Widget widget;
  final VoidCallback? onPressed;
  final bool mini;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: double.infinity,
        height: 50.h,
        padding: EdgeInsets.symmetric(horizontal: 40.w),
        child: FloatingActionButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          mini: mini,
          elevation: 10,
          backgroundColor:AppColors.firstColor,
          enableFeedback: false,
          onPressed: onPressed,
          child: widget,
        ),
      ),
    );
  }
}
