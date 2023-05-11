import 'dart:io';

import 'package:chat_app/application_layer/constants/app_strings.dart';
import 'package:chat_app/data_layer/message_model.dart';
import 'package:chat_app/presentation_layer/screens/chat_detailes/chat_details_cubit/states.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';



class ChatDetailsCubit extends Cubit<ChatDetailsStates> {

  ChatDetailsCubit() : super(ChatDetailsInitialState());

  static ChatDetailsCubit get(context) => BlocProvider.of(context);


Future<void>sendMessage({
  required String text,
  required String senderPhone,
  required String receiverPhone,
  String? photo
})async {
  MessageDataModel messageDataModel=MessageDataModel(
    text: text,
    dateTime: DateTime.now().toString(),
    senderPhone: senderPhone,
      receiverPhone: receiverPhone,
    photo: photo
  );
  emit(SendMessageLoadingState());
  FirebaseFirestore.instance
  .collection('Users')
  .doc(senderPhone)
  .collection('Chats')
  .doc(receiverPhone)
  .collection('Messages')
  .add(messageDataModel.toMap()).then((value) {
    emit(SendMessageSuccessState());
  }).catchError((error){
    emit(SendMessageErrorState(error));
  });
  FirebaseFirestore.instance
      .collection('Users')
      .doc(receiverPhone)
      .collection('Chats')
      .doc(senderPhone)
      .collection('Messages')
      .add(messageDataModel.toMap()).then((value) {
    emit(SendMessageSuccessState());
  }).catchError((error){
    emit(SendMessageErrorState(error));
  });
}

List<MessageDataModel>messages=[];
Future<void>getChatMessages({required String friendPhoneNumber})async {
  emit(GetChatsMessagesLoadingState());
  FirebaseFirestore.instance
  .collection('Users')
  .doc(AppStrings.phone)
  .collection('Chats')
  .doc(friendPhoneNumber)
  .collection('Messages')
  .orderBy('dateTime')
  .snapshots()
  .listen((event) {
    messages=[];
    for (var element in event.docs) {
      messages.add(MessageDataModel.fromJson(element.data()));
    }
    //scrollToLastMessage();
    emit(GetChatsMessagesSuccessState());
  });
}


  File? pickedImage;
  Future<void> pickImage() async {
    final image =
    await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      pickedImage = File(image.path);
      emit(PickImageSuccessState());
    } else {
      emit(PickImageErrorState());
    }
  }

  Future<void> sendPhotoMessage({
    required String text,
    required String senderPhone,
    required String receiverPhone,
    String? photo
}) async {
    emit(SendPhotoMessageLoadingState());
    await FirebaseStorage.instance
        .ref()
        .child("chats/${Uri.file(pickedImage!.path).pathSegments.last}")
        .putFile(pickedImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        sendMessage(text: text, senderPhone: senderPhone, receiverPhone: receiverPhone,photo: value);
      }).catchError((error) {
        emit(SendPhotoMessageErrorState(error.toString()));
      });
    });
  }

  Future<void> deletePickedImage()async {
    pickedImage=null;
    emit(DeletePickedImageSuccessState());
  }


  final ScrollController scrollController = ScrollController();
  void scrollToLastMessage() {
    emit(ScrollToLastMessageLoadingState());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 1),
        curve: Curves.easeOut,
      );
     // emit(ScrollToLastMessageSuccessState());
    });
  }


}
