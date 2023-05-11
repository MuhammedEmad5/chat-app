

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../application_layer/constants/app_colors.dart';

class DefaultFormField extends StatelessWidget {
  DefaultFormField({
    Key? key,
    required this.controller,
    required this.keyboardType,
    this.prefix,
    this.suffix,
    this.labelText,
    this.hintText,
    this.isPassword= false,
    this.cursorHeight,
    this.onChanged,
    this.onFieldSubmitted,
    required this.validator,
    this.suffixPressed,
    this.readOnly=false,
    this.height=50,
    this.maxLength,
    this.maxLines
  }) : super(key: key);

  TextEditingController controller;
  TextInputType keyboardType;
  IconData? prefix;
  IconData? suffix;
  String? labelText;
  String? hintText;
  bool isPassword ;
  double? cursorHeight = 25.h;
  ValueChanged<String>? onChanged;
  ValueChanged<String>? onFieldSubmitted;
  final FormFieldValidator validator;
  Function? suffixPressed;
  bool readOnly;
  double height;
  int? maxLength;
  int? maxLines;


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.firstSearchColor,
              AppColors.secondSearchColor,
            ],
            stops: const [0.4, 1.0],
          ),
        borderRadius: BorderRadius.circular(30.r),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            spreadRadius: 2,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      height: height,
      alignment: Alignment.center,
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        cursorHeight: cursorHeight,
        cursorColor: AppColors.white,
        obscureText: isPassword,
        maxLength: maxLength,
        readOnly: readOnly,
        onChanged: onChanged,
        maxLines: maxLines,
        validator: validator,
        onFieldSubmitted: onFieldSubmitted,
        style: Theme.of(context).textTheme.headlineSmall!.copyWith(
            color: AppColors.white,
            fontWeight: FontWeight.w400
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          prefixIcon: Icon(
            prefix,
            size: 30.w,
          ),
          prefixIconConstraints: BoxConstraints(maxWidth: 25.h),
          suffixIcon: suffix != null
              ? IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    suffixPressed!();
                  },
                  icon: Icon(
                    suffix,
                    size: 30.w,
                    color: AppColors.white,
                  ),
                )
              : null,
          labelText: labelText,
          hintText: hintText,
          hintStyle: Theme.of(context).textTheme.headlineSmall!.copyWith(
            color: AppColors.white,
            fontWeight: FontWeight.w400
          ),
          labelStyle:Theme.of(context).textTheme.labelSmall,
        ),
      ),
    );
  }
}
