import 'dart:io';
import 'package:chat_app/application_layer/constants/app_strings.dart';
import 'package:chat_app/data_layer/user_model.dart';
import 'package:chat_app/presentation_layer/screens/my_profile/my_profile_cubit/states.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';


class MyProfileCubit extends Cubit<MyProfileStates> {

  MyProfileCubit() : super(MyProfileInitialState());

  static MyProfileCubit get(context) => BlocProvider.of(context);
  
  UserDataModel? userDataModel;
  void getUserData(){
    emit(GetUserDataLoadingState());
    FirebaseFirestore.instance
        .collection('Users')
        .doc(AppStrings.phone)
        .get()
        .then((value) {
          userDataModel=UserDataModel.fromJson(value.data()!);
          emit(GetUserDataSuccessState());
    }).catchError((error){
      emit(GetUserDataErrorState(error.toString()));
    });
  }


  void updateUserData({
    required String name,
    required String bio,
}){
    emit(UpdateUserDataLoadingState());
    FirebaseFirestore.instance
        .collection('Users')
        .doc(AppStrings.phone)
        .update(
      {
        'name': name,
        'bio': bio,
      }
    )
        .then((value) {
      getUserData();
    }).catchError((error){
      emit(UpdateUserDataErrorState(error.toString()));
    });
  }


  File? pickedImage;
  Future<void> pickProfileImage() async {
    final image =
    await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      pickedImage = File(image.path);
      emit(PickImageSuccessState());
    } else {
      emit(PickImageErrorState());
    }
  }

  Future<void> upLoadProfileImage() async {
    emit(UploadProfileImageLoadingState());
    await FirebaseStorage.instance
        .ref()
        .child("usersProfileImage/${Uri.file(pickedImage!.path).pathSegments.last}")
        .putFile(pickedImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        saveUploadedProfileImage(value);
      }).catchError((error) {
        if (kDebugMode) {
          print(error.toString());
        }
        emit(UploadProfileImageErrorState(error.toString()));
      });
    }).catchError((error) {
      if (kDebugMode) {
        print('the error${error.toString()}');
      }
      emit(UploadProfileImageErrorState(error.toString()));
    });
  }

  void saveUploadedProfileImage(uploadedProfileImageUrl) {
    FirebaseFirestore.instance
        .collection('Users')
        .doc(AppStrings.phone)
        .update({
      'profileImage': uploadedProfileImageUrl,
    }).then((value) {
      getUserData();
    }).catchError((error) {
      emit(SaveUserProfileImageInFireStoreErrorState(error.toString()));
    });
  }

  Future<void> logOut() async {
    await FirebaseAuth.instance.signOut().then((value) {
      emit(LogOutSuccessState());
    }).catchError((error){
       emit(LogOutErrorState(error.toString()));
    });
  }

  Future<void> deleteProfileImage()async {
   await FirebaseFirestore.instance
        .collection('Users')
        .doc(AppStrings.phone)
        .update({
      'profileImage' :'',
    }).then((value) {
      getUserData();
    }).catchError((error){
      emit(DeleteProfileImageErrorState(error.toString()));
    });
  }

  Future<void> deletePickedImage()async {
    pickedImage=null;
    emit(DeletePickedImageSuccessState());
  }


}
