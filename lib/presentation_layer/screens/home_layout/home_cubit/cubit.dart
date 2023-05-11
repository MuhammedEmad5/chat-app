import 'package:chat_app/presentation_layer/screens/home_layout/home_cubit/states.dart';
import 'package:chat_app/presentation_layer/screens/my_friends_chats/my_frinds_chats_screen.dart';
import 'package:chat_app/presentation_layer/screens/calls_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../status_screen.dart';


class HomeCubit extends Cubit<HomeStates> {

  HomeCubit() : super(HomeInitialState());

  static HomeCubit get(context) => BlocProvider.of(context);


  List<Widget>homeScreens=[
    AllChatsScreen(),
    const StatusScreen(),
    const CallsScreen(),
  ];

  int selectedIndex = 0;
  void changeNavBar(int index){
    selectedIndex=index;
    emit(ChangeNavBarState());
  }


  List<Contact>? contacts;
  Future<void> getContacts() async {
    try{
      // Request permission to access contacts if needed
      PermissionStatus permission = await Permission.contacts.request();
      if (permission != PermissionStatus.granted) return;

      // Load all contacts from the phone
      contacts = await ContactsService.getContacts(withThumbnails: false);
      emit(GetAllContactsSuccessState());
    }catch(error){
      emit(GetAllContactsErrorState(error.toString()));
    }

  }

  List<String> allAppUsersPhoneNumbers = [];
  Future<void> getAppAllUsersPhoneNumber()async {
    emit(GetAllUsersPhoneNumberLoadingState());
    FirebaseFirestore.instance
        .collection('Users')
        .get()
        .then((value) {
          for (var element in value.docs) {
            String phoneNumber = element.data()['phone'];
            allAppUsersPhoneNumbers.add(phoneNumber);
          }
          emit(GetAllUsersPhoneNumberSuccessState());
    }).catchError((error){
      emit(GetAllUsersPhoneNumberErrorState());
    });
  }

  String addCountryCodeToPhoneNumber(String phoneNumber) {
    if(phoneNumber.length>11){
      return phoneNumber;
    }else {
      return '+2$phoneNumber';
    }
  }

  List<Contact> filteredContactsHaveAccount = [];
  Future<void> filterContacts(List<Contact> contacts, List<String> myNumbers) async {
    emit(GetMyContactHaveAccountLoadingState());
    filteredContactsHaveAccount = [];
    for (var contact in contacts) {
      for (var phoneNumber in contact.phones!) {
        if (myNumbers.contains(addCountryCodeToPhoneNumber(phoneNumber.value!))) {
          filteredContactsHaveAccount.add(contact);
          break;
        }
      }
    }
    emit(GetMyContactHaveAccountSuccessState());
  }


  Future<void> addFriend(String phone)async {
    emit(AddFriendsLoadingState());
    FirebaseFirestore.instance
        .collection('Users')
        .doc(addCountryCodeToPhoneNumber(phone))
        .get()
        .then((value) {
          FirebaseFirestore.instance
              .collection('MyFriends')
              .doc(addCountryCodeToPhoneNumber(phone))
              .set(value.data()!).then((value) {
            emit(AddFriendsSuccessState());
          }).catchError((error){
            emit(AddFriendsErrorState());
          });
    });
  }



}
