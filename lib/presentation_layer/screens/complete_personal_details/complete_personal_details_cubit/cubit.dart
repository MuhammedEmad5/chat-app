import 'dart:io';
import 'package:chat_app/application_layer/constants/app_strings.dart';
import 'package:chat_app/presentation_layer/screens/complete_personal_details/complete_personal_details_cubit/states.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../data_layer/user_model.dart';


class CompletePersonalDetailsCubit extends Cubit<CompletePersonalDetailsStates> {

  CompletePersonalDetailsCubit() : super(CompletePersonalDetailsInitialState());

  static CompletePersonalDetailsCubit get(context) => BlocProvider.of(context);

  FirebaseFirestore fireStore = FirebaseFirestore.instance;



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
        emit(UploadProfileImageErrorState());
      });
    }).catchError((error) {
      if (kDebugMode) {
        print('the error${error.toString()}');
      }
      emit(UploadProfileImageErrorState());
    });
  }

  void saveUploadedProfileImage(uploadedProfileImageUrl) {
    FirebaseFirestore.instance
        .collection('Users')
        .doc(AppStrings.phone)
        .update({'profileImage': uploadedProfileImageUrl}).then((value) {
      emit(SaveUserDataSuccessState());
    }).catchError((error) {
      emit(SaveUploadProfileImageErrorState());
    });
  }



  Future<void> saveUserDataInFireStore({
    required String name,
    required String phone,
    required String bio,
    required String uId,
  }) async {
    UserDataModel userDataModel = UserDataModel(
      name: name,
      phone: phone,
      uId: uId,
      profileImage: '',
      bio: bio,
    );
    emit(SaveUserDataLoadingState());
    FirebaseFirestore.instance
        .collection('Users')
        .doc(phone)
        .set(userDataModel.toMap())
        .then((value){
          pickedImage!=null
              ? upLoadProfileImage()
              : emit(SaveUserDataSuccessState());
        }
        );
  }



}
