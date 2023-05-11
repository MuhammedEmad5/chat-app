
abstract class MyFriendsChatsStates{}

class MyFriendsChatsInitialState extends MyFriendsChatsStates{}

class GetMyFriendsChatsDataLoadingState extends MyFriendsChatsStates{}
class GetMyFriendsChatsDataSuccessState extends MyFriendsChatsStates{}
class GetMyFriendsChatsDataErrorState extends MyFriendsChatsStates{
  final String error;

  GetMyFriendsChatsDataErrorState(this.error);
}





























