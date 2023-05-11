import 'dart:async';
import 'package:chat_app/application_layer/shared_preferences/shared_preferences.dart';
import 'package:chat_app/presentation_layer/screens/phone_register/phone_auth_cubit/cubit.dart';
import 'package:chat_app/presentation_layer/screens/phone_register/phone_auth_cubit/states.dart';
import 'package:chat_app/presentation_layer/screens/phone_register/phone_verification_screen.dart';
import 'package:chat_app/presentation_layer/widgets/loading.dart';
import 'package:chat_app/presentation_layer/widgets/snack_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../application_layer/constants/app_colors.dart';
import '../../../application_layer/constants/app_strings.dart';
import '../../widgets/default_button.dart';
import '../complete_personal_details/complete_personal_details_screen.dart';


class OtpScreen extends StatelessWidget {
  OtpScreen({Key? key, required this.phoneNumber, required this.countryCode}) : super(key: key);

  final String phoneNumber;
  final String countryCode;

  StreamController<ErrorAnimationType> errorController =
      StreamController<ErrorAnimationType>();
  TextEditingController otpController = TextEditingController();
  late String otpCode;

  Widget otpTitleText(context) {
    return Text(
      AppStrings.otpTitle,
      style: Theme.of(context).textTheme.displayLarge,
    );
  }

  Widget otpSubTitleText(context) {
    return RichText(
        text: TextSpan(
      children: [
        const TextSpan(
          text: AppStrings.otpSubTitle,
        ),
        TextSpan(
          text: phoneNumber,
          style: Theme.of(context).textTheme.headlineSmall!.copyWith(
              color: AppColors.firstColor,
              decoration: TextDecoration.underline,
              fontWeight: FontWeight.w400),
        ),
      ],
      style: Theme.of(context).textTheme.headlineSmall,
    ));
  }

  Widget pinCodeField(context) {
    return PinCodeTextField(
        length: 6,
        obscureText: false,
        animationType: AnimationType.fade,
        pinTheme: PinTheme(
          shape: PinCodeFieldShape.box,
          borderRadius: BorderRadius.circular(5),
          fieldHeight: 50,
          fieldWidth: 40,
          activeFillColor: AppColors.secondColor.withOpacity(0.5),
          activeColor: AppColors.secondColor.withOpacity(0.1),
          selectedFillColor: AppColors.white,
          selectedColor: AppColors.secondColor,
          inactiveFillColor: AppColors.white,
          inactiveColor: AppColors.firstColor.withOpacity(0.2),
        ),
        animationDuration: const Duration(milliseconds: 300),
        backgroundColor: Colors.transparent,
        enableActiveFill: true,
        errorAnimationController: errorController,
        controller: otpController,
        onCompleted: (code) {
          otpCode = code;
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

  Widget verifyButton() {
    return BlocProvider(
      create: (BuildContext context) => PhoneAuthCubit(),
      child: BlocConsumer<PhoneAuthCubit, PhoneAuthStates>(
        listenWhen: (previous, current) {
          return previous != current;
        },
        listener: (BuildContext context, state) {
          if (state is PhoneOtpVerifiedSuccessState) {
            CashHelper.putStringData(key: 'uId', value: state.uId).then((value) {
              AppStrings.uId=CashHelper.getStringData(key: 'uId').toString();
            });
            CashHelper.putStringData(key: 'phone', value: phoneNumber).then((value) {
              AppStrings.phone=CashHelper.getStringData(key: 'phone').toString();
            });
            CashHelper.putStringData(key: 'countryCode', value: phoneNumber).then((value) {
              AppStrings.countryCode=CashHelper.getStringData(key: 'countryCode').toString();
            });
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => CompletePersonalDetailsScreen(
                        phoneNumber: phoneNumber,
                    ),
                ),
            );
          }
          if (state is PhoneAuthErrorState) {
            defaultSnackBar(context, state.error);
          }
        },
        builder: (BuildContext context, state) {
          PhoneAuthCubit cubit = PhoneAuthCubit.get(context);
          return state is PhoneOtpVerifiedLoadingState
              ? const AppLoading()
              : DefaultButton(
            text: 'Verify',
            onPressed: () {
              cubit.submitOtp(otpCode);
            },
          );
        },
      ),
    );
  }

  Widget doNotReceiveText(context) {
    return Center(
      child: Text(
        AppStrings.doNotReceive,
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }

  Widget reSendCodeButton(context) {
    return BlocProvider(
      create: (BuildContext context) => PhoneAuthCubit(),
      child: BlocBuilder<PhoneAuthCubit, PhoneAuthStates>(
        builder: (BuildContext context, Object? state) {
          return TextButton(
            onPressed: () {
              PhoneAuthCubit.get(context).reSend(phoneNumber,
                  CashHelper.getIntData(key: 'forceResendingToken')!);
            },
            style: ButtonStyle(
                overlayColor:
                    MaterialStateProperty.all<Color>(Colors.transparent)),
            child: Text(
              'Resend code',
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: AppColors.firstColor, fontWeight: FontWeight.w600),
            ),
          );
        },
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

  Widget changeNumberButton(context) {
    return TextButton(
      onPressed: () {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>PhoneVerificationScreen()),);
      },
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.all<Color>(Colors.transparent),
      ),
      child: Text(
        'Change phone number',
        style: Theme.of(context)
            .textTheme
            .bodySmall!
            .copyWith(color: AppColors.firstColor, fontWeight: FontWeight.w600),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: double.minPositive,
        actions: [
          IconButton(
              onPressed: (){
                print(countryCode);
              },
              icon: Icon(Icons.abc_rounded)
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                otpTitleText(context),
                SizedBox(height: 25.h),
                otpSubTitleText(context),
                SizedBox(height: 100.h),
                pinCodeField(context),
                SizedBox(height: 35.h),
                Padding(
                  padding: EdgeInsetsDirectional.only(start: 180.0.w),
                  child: verifyButton(),
                ),
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
