import 'dart:async';

import 'package:chat_app/application_layer/app_colors.dart';
import 'package:chat_app/presentation_layer/screens/home_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../application_layer/app_strings.dart';
import '../../business_logic_layer/phone_auth_cubit/cubit.dart';
import '../../business_logic_layer/phone_auth_cubit/states.dart';
import '../widgets/default_button.dart';

class OtpScreen extends StatelessWidget {
  OtpScreen({Key? key,required this.phoneNumber}) : super(key: key);

  final String phoneNumber;

  StreamController<ErrorAnimationType> errorController =
      StreamController<ErrorAnimationType>();
  TextEditingController otpController = TextEditingController();
  String? otpCode;
  
  
  Widget otpTitleText(context){
    return Text(
      AppStrings.otpTitle,
      style: Theme.of(context).textTheme.displayLarge,
    );
  }
  
  Widget otpSubTitleText(context){
    return Text(
      AppStrings.otpSubTitle,
      style: Theme.of(context).textTheme.headlineMedium,
    );
  }
  
  Widget pinCodeField(context){
    return PinCodeTextField(
        length: 6,
        obscureText: false,
        animationType: AnimationType.fade,
        pinTheme: PinTheme(
          shape: PinCodeFieldShape.box,
          borderRadius: BorderRadius.circular(5),
          fieldHeight: 50,
          fieldWidth: 40,
          activeFillColor: Colors.green[300],
          activeColor: Colors.green[300],
          selectedFillColor: AppColors.white,
          selectedColor: AppColors.secondColor,
          inactiveFillColor: AppColors.firstColor.withOpacity(0.5),
          inactiveColor: AppColors.firstColor.withOpacity(0.2),
        ),
        animationDuration: const Duration(milliseconds: 300),
        backgroundColor: Colors.transparent,
        enableActiveFill: true,
        errorAnimationController: errorController,
        controller: otpController,
        onCompleted: (code) {
          otpCode=code;
        },
        onChanged: (value) {
          if (kDebugMode) {
            print(value);
          }
        },
        beforeTextPaste: (text) {
          if (kDebugMode) {
            print("Allowing to paste $text");
          }
          return true;
        },
        appContext: context);
  }
  
  Widget verifyButton(){
    return BlocProvider(
      create: (BuildContext context) =>PhoneAuthCubit(),
      child: BlocConsumer<PhoneAuthCubit,PhoneAuthStates>(
        listenWhen: (previous, current) {
          return previous != current;
        },
        listener: (BuildContext context, state){
          if (state is PhoneOtpVerifiedSuccessState){
            Navigator.push(context, MaterialPageRoute(builder: (_)=>const HomeScreen()));
          }
          if (state is PhoneAuthErrorState){
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text((state).error)));
          }
        },
        builder: (BuildContext context, state){
          PhoneAuthCubit cubit=PhoneAuthCubit.get(context);
         return Row(
           children: [
             const Spacer(),
             Expanded(
               child: DefaultButton(
                 widget: const Text(
                   'Verify',
                 ),
                 onPressed: () async{
                   await cubit.submitOtp(otpCode!);
                 },
               ),
             ),
           ],
         );
        },
      ),
    );
  }
  
  Widget doNotReceiveText(context){
    return Text(
      AppStrings.doNotReceive,
      style: Theme.of(context).textTheme.titleLarge,
    );
  }
  
  Widget reSendCodeButton(context){
    return TextButton(
      onPressed: () {},
      style: ButtonStyle(
          overlayColor:
          MaterialStateProperty.all<Color>(Colors.transparent)),
      child: Text(
        'Resend code',
        style: Theme.of(context).textTheme.bodySmall!.copyWith(
            color: AppColors.firstColor,
            fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget dividerContainer() {
    return Container(
      height: 15.h,
      width: 2.w,
      color: AppColors.secondColor,
    );
  }

  Widget changeNumberButton(context){
    return TextButton(
      onPressed: () {},
      style: ButtonStyle(
        overlayColor:
        MaterialStateProperty.all<Color>(Colors.transparent),
      ),
      child: Text(
        'Change phone number',
        style: Theme.of(context).textTheme.bodySmall!.copyWith(
            color: AppColors.firstColor,
            fontWeight: FontWeight.w600),
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: double.minPositive,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                otpTitleText(context),
                SizedBox(height: 25.h),
                otpSubTitleText(context),
                SizedBox(height: 100.h),
                pinCodeField(context),
                SizedBox(height: 35.h),
                verifyButton(),
                SizedBox(height: 45.h),
                doNotReceiveText(context),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    reSendCodeButton(context),
                    dividerContainer(),
                    changeNumberButton(context),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
