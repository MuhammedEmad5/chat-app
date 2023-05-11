import 'package:chat_app/application_layer/constants/app_strings.dart';
import 'package:chat_app/application_layer/shared_preferences/shared_preferences.dart';
import 'package:chat_app/presentation_layer/widgets/default_button.dart';
import 'package:chat_app/presentation_layer/widgets/photo_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../application_layer/constants/app_colors.dart';
import '../../widgets/loading.dart';
import '../../widgets/text_form_widget.dart';
import '../home_layout/home_Layout.dart';
import 'complete_personal_details_cubit/cubit.dart';
import 'complete_personal_details_cubit/states.dart';


class CompletePersonalDetailsScreen extends StatelessWidget {
  CompletePersonalDetailsScreen({Key? key, required this.phoneNumber})
      : super(key: key);

  final TextEditingController nameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final String phoneNumber;

  AppBar appBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      toolbarHeight: double.minPositive,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: AppColors.firstColor.withOpacity(0.96),
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );
  }

  Decoration containerDecoration() {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppColors.firstColor,
          AppColors.secondColor,
        ],
      ),
    );
  }

  Widget pickedProfileImage(cubit,context){
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => FilePhotoView(imageFile: cubit.pickedImage!),
          ),
        );
      },
      child: CircleAvatar(
        backgroundImage: FileImage(
          cubit.pickedImage!,
        ),
        radius: 70,
      ),
    );
  }

  Widget defaultProfileImage(){
    return const CircleAvatar(
      backgroundImage: AssetImage(
        "assets/images/no_image.png",
      ),
      radius: 70,
    );
  }

  Widget cameraIconButton(cubit){
    return CircleAvatar(
      radius: 20.r,
      backgroundColor: AppColors.firstColor,
      child: IconButton(
        onPressed: () {
          cubit.pickProfileImage();
        },
        icon: Icon(
          Icons.photo_camera,
          size: 25.w,
          color: AppColors.white,
        ),
        splashRadius: 0.1,
      ),
    );
  }

  Widget avatarImage() {
    return BlocBuilder<CompletePersonalDetailsCubit,
        CompletePersonalDetailsStates>(
      builder: (BuildContext context, state) {
        var cubit = CompletePersonalDetailsCubit.get(context);
        return Center(
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              cubit.pickedImage != null
                  ? pickedProfileImage(cubit, context)
                  : defaultProfileImage(),
              cameraIconButton(cubit),
            ],
          ),
        );
      },
    );
  }

  Widget nameTextField() {
    return DefaultFormField(
      controller: nameController,
      keyboardType: TextInputType.name,
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter your name';
        }
        return null;
      },
      hintText: 'full name',
      suffix: Icons.person_2_outlined,
    );
  }

  Widget bioTextFiled() {
    return DefaultFormField(
      controller: bioController,
      keyboardType: TextInputType.name,
      validator: (value) {
        return null;
      },
      hintText: 'bio...',
      suffix: Icons.ac_unit_outlined,
    );
  }

  Widget nextButton(context) {
    return BlocConsumer<CompletePersonalDetailsCubit,
        CompletePersonalDetailsStates>(
      listener: (BuildContext context, state) {
        if (state is SaveUserDataSuccessState) {
          CashHelper.putBoolData(key: 'login', value: true);
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => const HomeScreen()));
        }
      },
      builder: (BuildContext context, state) {
        var cubit = CompletePersonalDetailsCubit.get(context);
        return state is SaveUserDataLoadingState
            ? const AppLoading()
            : DefaultButton(
              text: "Next",
              onPressed: () {
                cubit.saveUserDataInFireStore(
                  name: nameController.text,
                  phone: phoneNumber,
                  bio: bioController.text,
                  uId: AppStrings.uId,
                );
              },
            );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => CompletePersonalDetailsCubit(),
      child: Scaffold(
        appBar: appBar(),
        body: Container(
          decoration: containerDecoration(),
          child: Center(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0.r),
                  ),
                  color: AppColors.white,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: 15.0.h, horizontal: 10.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        avatarImage(),
                        SizedBox(height: 50.h),
                        nameTextField(),
                        SizedBox(height: 20.h),
                        bioTextFiled(),
                        SizedBox(height: 50.h),
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
          ),
        ),
      ),
    );
  }
}
