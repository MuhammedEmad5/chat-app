import 'package:chat_app/application_layer/constants/app_strings.dart';
import 'package:chat_app/presentation_layer/screens/phone_register/phone_auth_cubit/cubit.dart';
import 'package:chat_app/presentation_layer/screens/phone_register/phone_auth_cubit/states.dart';
import 'package:chat_app/presentation_layer/widgets/default_button.dart';
import 'package:chat_app/presentation_layer/widgets/snack_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import '../../widgets/loading.dart';
import 'otp_screen.dart';



class PhoneVerificationScreen extends StatelessWidget {
  PhoneVerificationScreen({Key? key}) : super(key: key);

  final TextEditingController phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
   String? phoneNumber;
  String? countryCode;

  Widget phoneTitleText(context){
    return Text(
      AppStrings.phoneNumberTitle,
      style: Theme.of(context).textTheme.displayLarge,
    );
  }

  Widget phoneSubTitleText(context){
    return Text(
      AppStrings.phoneNumberSubTitle,
      style: Theme.of(context).textTheme.headlineMedium,
    );
  }

  Widget phoneField() {
    return IntlPhoneField(
      decoration: InputDecoration(
        labelText: 'Phone Number',
        border: OutlineInputBorder(
            borderSide: const BorderSide(),
            borderRadius: BorderRadius.circular(20.r)
        ),
      ),
      initialCountryCode: 'EG',
      onChanged: (phone) {
        if (kDebugMode) {
          print(phone.completeNumber);
        }
      },
      validator: (phone){
        if (phone!.number.isEmpty) {
          return 'Phone number is required.';
        }
        return null;
      },
      onSaved: (phone){
        phoneNumber=phone!.completeNumber.toString();
        countryCode=phone.countryCode;
      },
    );
  }

  void showProgressIndicator(BuildContext context) {
    AlertDialog alertDialog = const AlertDialog(
      backgroundColor: Colors.transparent,
      elevation: 0,

      content: Center(
        child: AppLoading()
      ),
    );

    showDialog(
      barrierColor: Colors.white.withOpacity(0),
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return alertDialog;
      },
    );
  }

  Widget nextButton(context){
    return BlocProvider(
      create: (BuildContext context) =>PhoneAuthCubit(),
      child: BlocConsumer<PhoneAuthCubit,PhoneAuthStates>(
        listenWhen: (previous,current){
          return previous !=current;
        },
        listener: (BuildContext context, state) {
          if (state is PhoneAuthSmsSentSuccessState){
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (_)=>OtpScreen(phoneNumber: phoneNumber!, countryCode: countryCode!,)));
            defaultSnackBar(context, 'Please check your phone for the verification code');
          }
          if (state is PhoneAuthErrorState){
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text((state).error,),));
          }
        },
        builder: (BuildContext context, state) {
          PhoneAuthCubit cubit=PhoneAuthCubit.get(context);
          return state is PhoneAuthLoadingState
              ? const AppLoading()
              : DefaultButton(
            text: 'Next',
            onPressed: () {
              showProgressIndicator(context);
              if(_formKey.currentState!.validate()){
                Navigator.pop(context);
                _formKey.currentState!.save();
                cubit.verifyPhoneNumber(phoneNumber!);
              }else {
                Navigator.pop(context);
                return;
              }
            },
          );
        },
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
        padding: EdgeInsets.all(15.0.w),
        child: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 35.h),
                  phoneTitleText(context),
                  SizedBox(height: 25.h),
                  phoneSubTitleText(context),
                  SizedBox(height: 100.h),
                  phoneField(),
                  SizedBox(height: 35.h),
                  Padding(
                    padding: EdgeInsetsDirectional.only(start: 180.0.w),
                    child: nextButton(context),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
