import 'package:chat_app/application_layer/constants/app_colors.dart';
import 'package:chat_app/application_layer/constants/app_strings.dart';
import 'package:chat_app/data_layer/message_model.dart';
import 'package:chat_app/data_layer/user_model.dart';
import 'package:chat_app/presentation_layer/screens/chat_detailes/chat_details_cubit/cubit.dart';
import 'package:chat_app/presentation_layer/screens/chat_detailes/chat_details_cubit/states.dart';
import 'package:chat_app/presentation_layer/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({super.key, required this.userDataModel});

  final TextEditingController textController = TextEditingController();
  final UserDataModel userDataModel;

  Widget myFriendData(context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 20.r,
          backgroundImage: NetworkImage(
            userDataModel.profileImage!,
          ),
        ),
        SizedBox(width: 10.w),
        Text(
          userDataModel.name!,
          style: Theme.of(context)
              .textTheme
              .headlineMedium!
              .copyWith(fontWeight: FontWeight.w500),
        )
      ],
    );
  }

  AppBar appBar(context) {
    return AppBar(
      backgroundColor: AppColors.secondColor.withOpacity(0.2),
      systemOverlayStyle:
          const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
      titleSpacing: 0.0,
      title: myFriendData(context),
    );
  }

  Widget myMessageItemBuilder(MessageDataModel model){
    return Padding(
      padding: EdgeInsetsDirectional.only(
        start: 50.w,
        end: 8.w,
      ),
      child: Align(
        alignment: Alignment.centerRight,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 5.w),
          decoration: BoxDecoration(
            color: AppColors.secondColor.withOpacity(0.5),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(12.r),
              topRight: Radius.circular(12.r),
              topLeft: Radius.circular(12.r),
            ),
          ),
          child: Column(
            children: [
              model.photo!=null
                  ? Image(
                  image: NetworkImage(
                    model.photo!,
                  ),
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              )
                  :const SizedBox(),
              model.photo!=null? SizedBox(height: 10):const SizedBox(),
              Text(
                model.text!,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget myFriendMessageItemBuilder(MessageDataModel model){
    return Padding(
      padding: EdgeInsetsDirectional.only(
        start: 8.w,
        end: 50.w,
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 5.w),
          decoration: BoxDecoration(
            color: AppColors.firstColor.withOpacity(0.5),
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(12.r),
              topRight: Radius.circular(12.r),
              topLeft: Radius.circular(12.r),
            ),
          ),
          child: Column(
            children: [
              model.photo!=null
                  ? Image(
                image: NetworkImage(
                  model.photo!,
                ),
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              )
                  :const SizedBox(),
              model.photo!=null? SizedBox(height: 10):const SizedBox(),
              Text(
                model.text!,
              ),
            ],
          )
        ),
      ),
    );
  }

  Widget loadedImage(){
    return BlocBuilder<ChatDetailsCubit,ChatDetailsStates>(
      builder: (BuildContext context, state) {
        return ChatDetailsCubit.get(context).pickedImage!=null
            ? Image(
          image: FileImage(
            ChatDetailsCubit.get(context).pickedImage!,
          ),
          height: 100,
          width: 100,
          fit: BoxFit.cover,
        )
            : const SizedBox();
      },
    );
  }

  Widget textForm(context){
    return Expanded(
      child: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(left: 10.h),
          padding: EdgeInsets.symmetric(horizontal: 10.h),
          decoration: BoxDecoration(
              border: Border.all(
                width: 0.2.w,

              ),
              borderRadius: BorderRadius.all(Radius.circular(20.r))
          ),
          child: TextFormField(
            controller: textController,
            maxLines: null,
            decoration: InputDecoration(
              hintText: 'Enter your message',
              hintStyle: Theme.of(context).textTheme.bodySmall,
              border: InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }

  Widget sendIconButton() {
    return BlocConsumer<ChatDetailsCubit, ChatDetailsStates>(
      listener: (BuildContext context, state){
        if(state is SendMessageSuccessState){
          ChatDetailsCubit.get(context).pickedImage=null;
        }
      },
      builder: (BuildContext context, state) {
        var cubit = ChatDetailsCubit.get(context);
        return IconButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            if (textController.text.isNotEmpty || cubit.pickedImage != null) {
             // cubit.scrollToLastMessage();
              cubit.pickedImage != null
                  ? cubit
                      .sendPhotoMessage(
                          text: textController.text,
                          senderPhone: AppStrings.phone,
                          receiverPhone: userDataModel.phone!)
                      .then((value) {
                      textController.text = '';
                    })
                  : cubit
                      .sendMessage(
                          text: textController.text,
                          senderPhone: AppStrings.phone,
                          receiverPhone: userDataModel.phone!)
                      .then((value) {
                      textController.text = '';
                    });
            }
          },
          icon: Icon(
            Icons.send,
            color: AppColors.firstColor,
          ),
        );
      },
    );
  }

  Widget chosePhotoIconButton(){
    return BlocBuilder<ChatDetailsCubit,ChatDetailsStates>(
      builder: (BuildContext context, state) {
        var cubit=ChatDetailsCubit.get(context);
        return IconButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            cubit.pickImage();
          },
          icon: Icon(
            Icons.image,
            color: AppColors.firstColor,
          ),
        );
      },
    );
  }

  Widget buildTextComposer(context) {
    return Row(
      children: [
        textForm(context),
        chosePhotoIconButton(),
        sendIconButton(),
      ],
    );
  }

  Widget messagesListViewBuilder(){
    return BlocBuilder<ChatDetailsCubit,ChatDetailsStates>(
      builder: (BuildContext context, state) {
        var messages=ChatDetailsCubit.get(context).messages;
        return state is ScrollToLastMessageLoadingState
        ? const Center(child: AppLoading())
        : Expanded(
          child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              controller: ChatDetailsCubit.get(context).scrollController,
              itemBuilder: (context,index){
                if(AppStrings.phone==messages[index].senderPhone){
                  return myMessageItemBuilder(messages[index]);
                }else {
                  return myFriendMessageItemBuilder(messages[index]);
                }
              },
              separatorBuilder: (context,index)=>SizedBox(height: 5.h),
              itemCount: messages.length
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>ChatDetailsCubit()
        ..getChatMessages(friendPhoneNumber: userDataModel.phone!),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: appBar(context),
        body: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0.h),
          child: Column(
            children: [
              messagesListViewBuilder(),
              loadedImage(),
              buildTextComposer(context)
            ],
          ),
        ),
      ),
    );
  }
}
