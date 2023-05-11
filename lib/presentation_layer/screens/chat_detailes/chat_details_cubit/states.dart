
abstract class ChatDetailsStates{}

class ChatDetailsInitialState extends ChatDetailsStates{}

class SendMessageLoadingState extends ChatDetailsStates{}
class SendMessageSuccessState extends ChatDetailsStates{}
class SendMessageErrorState extends ChatDetailsStates{
  final String error;

  SendMessageErrorState(this.error);
}

class GetChatsMessagesLoadingState extends ChatDetailsStates{}
class GetChatsMessagesSuccessState extends ChatDetailsStates{}

class PickImageSuccessState extends ChatDetailsStates{}
class PickImageErrorState extends ChatDetailsStates{}

class SendPhotoMessageLoadingState extends ChatDetailsStates{}
class SendPhotoMessageErrorState extends ChatDetailsStates{
  final String error;

  SendPhotoMessageErrorState(this.error);
}

class DeletePickedImageSuccessState extends ChatDetailsStates{}

class ScrollToLastMessageLoadingState extends ChatDetailsStates{}
class ScrollToLastMessageSuccessState extends ChatDetailsStates{}




























