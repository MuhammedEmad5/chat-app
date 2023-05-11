
abstract class HomeStates{}

class HomeInitialState extends HomeStates{}

class ChangeNavBarState extends HomeStates{}

class GetAllContactsSuccessState extends HomeStates{}
class GetAllContactsErrorState extends HomeStates{
  final String error;

  GetAllContactsErrorState(this.error);
}

class GetAllUsersPhoneNumberLoadingState extends HomeStates{}
class GetAllUsersPhoneNumberSuccessState extends HomeStates{}
class GetAllUsersPhoneNumberErrorState extends HomeStates{}


class GetMyContactHaveAccountLoadingState extends HomeStates{}
class GetMyContactHaveAccountSuccessState extends HomeStates{}

class AddFriendsLoadingState extends HomeStates{}
class AddFriendsSuccessState extends HomeStates{}
class AddFriendsErrorState extends HomeStates{}































