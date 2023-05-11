import 'package:chat_app/data_layer/user_model.dart';
import 'package:chat_app/presentation_layer/screens/my_friends_chats/my_friends_chats_cubit/states.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';



class MyFriendsChatsCubit extends Cubit<MyFriendsChatsStates> {

  MyFriendsChatsCubit() : super(MyFriendsChatsInitialState());

  static MyFriendsChatsCubit get(context) => BlocProvider.of(context);
  
  List<UserDataModel> myFriendsChats=[];
  void getMyFriendsChats(){
    emit(GetMyFriendsChatsDataLoadingState());
    FirebaseFirestore.instance
        .collection('MyFriends')
        .get()
        .then((value) {
          for (var user in value.docs) {
            myFriendsChats.add(UserDataModel.fromJson(user.data()));
          }
          emit(GetMyFriendsChatsDataSuccessState());
    }).catchError((error){
      print(error.toString());
      emit(GetMyFriendsChatsDataErrorState(error.toString()));
    });
  }




}
