
abstract class MyProfileStates{}

class MyProfileInitialState extends MyProfileStates{}

class GetUserDataLoadingState extends MyProfileStates{}
class GetUserDataSuccessState extends MyProfileStates{}
class GetUserDataErrorState extends MyProfileStates{
  final String error;

  GetUserDataErrorState(this.error);
}

class UpdateUserDataLoadingState extends MyProfileStates{}
class UpdateUserDataErrorState extends MyProfileStates{
  final String error;

  UpdateUserDataErrorState(this.error);

}


class PickImageSuccessState extends MyProfileStates{}
class PickImageErrorState extends MyProfileStates{}

class UploadProfileImageLoadingState extends MyProfileStates{}
class UploadProfileImageErrorState extends MyProfileStates{
  final String error;
  UploadProfileImageErrorState(this.error);
}

class SaveUserProfileImageInFireStoreErrorState extends MyProfileStates{
  final String error;
  SaveUserProfileImageInFireStoreErrorState(this.error);
}

class LogOutSuccessState extends MyProfileStates{}
class LogOutErrorState extends MyProfileStates{
  final String error;
  LogOutErrorState(this.error);
}

class DeleteProfileImageSuccessState extends MyProfileStates{}
class DeleteProfileImageErrorState extends MyProfileStates{
  final String error;
  DeleteProfileImageErrorState(this.error);
}

class DeletePickedImageSuccessState extends MyProfileStates{}


























