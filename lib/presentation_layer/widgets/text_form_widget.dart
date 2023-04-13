

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../application_layer/app_colors.dart';

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
    this.height=60
  }) : super(key: key);

  TextEditingController controller;
  TextInputType keyboardType;
  IconData? prefix;
  IconData? suffix;
  String? labelText;
  String? hintText;
  bool isPassword ;
  double? cursorHeight = 25;
  ValueChanged<String>? onChanged;
  ValueChanged<String>? onFieldSubmitted;
  final FormFieldValidator validator;
  Function? suffixPressed;
  bool readOnly;
  double height;


  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      color: AppColors.white,
      elevation: 10,
      shape: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.r),
        borderSide:  BorderSide(color: AppColors.white)
      ),
      child: Container(
        height: height,
        alignment: Alignment.center,
        child: TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          cursorHeight: cursorHeight,
          obscureText: isPassword,
          readOnly: readOnly,
          onChanged: onChanged,
          validator: validator,
          onFieldSubmitted: onFieldSubmitted,
          style: Theme.of(context).textTheme.headlineMedium,
          decoration: InputDecoration(
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            focusedErrorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            prefixIcon: Icon(
              prefix,
              size: 20.w,
            ),
            suffixIcon: suffix != null
                ? IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      suffixPressed!();
                    },
                    icon: Icon(
                      suffix,
                      size: 20.w,
                    ),
                  )
                : null,
            labelText: labelText,
            hintText: hintText,
            hintStyle: Theme.of(context).textTheme.bodySmall,
            labelStyle:Theme.of(context).textTheme.labelSmall,
          ),
        ),
      ),
    );
  }
}
