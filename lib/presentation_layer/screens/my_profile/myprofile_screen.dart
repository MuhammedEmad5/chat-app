import 'package:chat_app/presentation_layer/widgets/loading.dart';
import 'package:chat_app/presentation_layer/widgets/photo_view.dart';
import 'package:chat_app/presentation_layer/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../application_layer/constants/app_colors.dart';
import '../phone_register/phone_verification_screen.dart';
import 'my_profile_cubit/cubit.dart';
import 'my_profile_cubit/states.dart';


class MyProfileScreen extends StatelessWidget {
  MyProfileScreen({Key? key}) : super(key: key);

  TextEditingController nameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  TextEditingController phoneController = TextEditingController();


  Widget logOutIconButton(context,MyProfileCubit cubit){
    return IconButton(
      onPressed: (){
        cubit.logOut();
      },
      icon: Icon(
        Icons.logout,
        color: AppColors.firstColor,
      )
    );
  }

  AppBar appBar(context,MyProfileCubit cubit){
    return AppBar(
      title: Text(
        'Profile Settings',
        style: Theme.of(context)
            .textTheme
            .headlineSmall!
            .copyWith(fontWeight: FontWeight.w500),
      ),
      actions: [
        logOutIconButton(context,cubit),
      ],
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

  Widget noProfileImageInFireStore() {
    return CircleAvatar(
      radius: 75.r,
      backgroundColor: Colors.grey,
      child: ClipOval(
        child: SizedBox(
          width: 150.w,
          height: 150.h,
          child: Image.asset(
            'assets/images/no_image.png',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget userProfileImage(context,MyProfileCubit cubit){
    return cubit.userDataModel!.profileImage == ''
        ? noProfileImageInFireStore()
        : InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => NetworkPhotoView(
                    imageUrl: cubit.userDataModel!.profileImage!,
                  ),
                ),
              );
            },
            child: CircleAvatar(
              radius: 75.r,
              backgroundColor: Colors.grey,
              child: ClipOval(
                child: SizedBox(
                  width: 150.w,
                  height: 150.h,
                  child: Image.network(
                    cubit.userDataModel!.profileImage!,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          );
  }

  Widget pickedProfileImage(context,cubit){
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                FilePhotoView(imageFile: cubit.pickedImage!),
          ),
        );
      },
      child: CircleAvatar(
        radius: 75.r,
        backgroundColor: Colors.grey,
        child: ClipOval(
          child: SizedBox(
            width: 150.w,
            height: 150.h,
            child: Image.file(
              cubit.pickedImage!,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }

  Widget profileImageCircleAvatar(MyProfileCubit cubit,context){
    return Center(
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          cubit.pickedImage == null
              ? userProfileImage(context, cubit)
              : pickedProfileImage(context, cubit),
          cameraIconButton(cubit),
        ],
      ),
    );
  }

  Widget saveProfileImageButton(MyProfileCubit cubit){
    return ElevatedButton(
      onPressed: () {
        cubit.upLoadProfileImage().then((value) {
          cubit.pickedImage=null;
        });
      },
      child: const Text('Save profile image'),
    );
  }

  Widget saveUserChangesButton(MyProfileCubit cubit){
    return ElevatedButton(
      onPressed: () {
        cubit.updateUserData(name: nameController.text, bio: bioController.text);
      },
      child: const Text('Save'),
    );
  }

  Widget deleteProfileImageIconButton(MyProfileCubit cubit){
    return IconButton(
      onPressed: () {
        cubit.deleteProfileImage();
      },
      icon: Icon(
        Icons.delete,
        size: 30.sp,
        color: AppColors.white,
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MyProfileCubit, MyProfileStates>(
      listener: (BuildContext context, state) {
        if(state is LogOutSuccessState){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>PhoneVerificationScreen()),);
        }
        if(state is LogOutErrorState){
          defaultSnackBar(context, state.error);
        }
        if(state is GetUserDataErrorState){
          defaultSnackBar(context, state.error);
        }
        if(state is UpdateUserDataErrorState){
          defaultSnackBar(context, state.error);
        }
        if(state is UploadProfileImageErrorState){
          defaultSnackBar(context, state.error);
        }
        if(state is SaveUserProfileImageInFireStoreErrorState){
          defaultSnackBar(context, state.error);
        }
      },
      builder: (BuildContext context, Object? state) {
        MyProfileCubit cubit = MyProfileCubit.get(context);
        final userDataModel = MyProfileCubit.get(context).userDataModel;
        if (userDataModel != null) {
          nameController.text = userDataModel.name!;
          bioController.text = userDataModel.bio!;
          phoneController.text = userDataModel.phone!;
        }
        return Scaffold(
          appBar: appBar(context,cubit),
          body: userDataModel == null
              ? const Center(child: AppLoading())
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: 16.h),
                        profileImageCircleAvatar(cubit,context),
                        SizedBox(height: 16.h),
                        cubit.pickedImage == null
                            ? const SizedBox()
                            : state is UploadProfileImageLoadingState
                                ? const AppLoading()
                                : saveProfileImageButton(cubit),
                        cubit.pickedImage == null
                            ? const SizedBox()
                            : SizedBox(height: 16.h),
                        TextField(
                          controller: nameController,
                          decoration: const InputDecoration(
                            labelText: 'Name',
                          ),
                        ),
                        SizedBox(height: 16.h),
                        TextField(
                          controller: bioController,
                          maxLength: 150,
                          decoration: const InputDecoration(
                            labelText: 'Bio',
                          ),
                          maxLines: null,
                        ),
                        SizedBox(height: 16.h),
                        TextField(
                          controller: phoneController,
                          readOnly: true,
                          decoration: const InputDecoration(
                            labelText: 'Phone Number',
                          ),
                          keyboardType: TextInputType.phone,
                        ),
                        SizedBox(height: 16.h),
                        state is UpdateUserDataLoadingState
                            ? const AppLoading()
                            : saveUserChangesButton(cubit),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }
}
