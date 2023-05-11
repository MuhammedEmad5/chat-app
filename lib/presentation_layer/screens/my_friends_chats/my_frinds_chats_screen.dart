import 'package:chat_app/data_layer/user_model.dart';
import 'package:chat_app/presentation_layer/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../widgets/text_form_widget.dart';
import '../chat_detailes/chat_details_screen.dart';
import '../my_profile/my_profile_cubit/cubit.dart';
import '../my_profile/my_profile_cubit/states.dart';
import '../my_profile/myprofile_screen.dart';
import 'my_friends_chats_cubit/cubit.dart';
import 'my_friends_chats_cubit/states.dart';

class AllChatsScreen extends StatelessWidget {
  AllChatsScreen({Key? key}) : super(key: key);

  TextEditingController searchController = TextEditingController();

  Widget leadingCircleAvatar(context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => MyProfileScreen()));
      },
      child: BlocBuilder<MyProfileCubit, MyProfileStates>(
        builder: (BuildContext context, state) {
          return MyProfileCubit.get(context).userDataModel != null
              ? CircleAvatar(
            backgroundImage: NetworkImage(
              MyProfileCubit.get(context).userDataModel!.profileImage!,
            ),
          )
              :const CircleAvatar(
            backgroundImage: AssetImage(
              'assets/images/no_image.png',
            ),
          );
        },
      ),
    );
  }

  Widget searchFormField() {
    return Expanded(
      child: DefaultFormField(
        controller: searchController,
        keyboardType: TextInputType.text,
        validator: (value) {
          if (value.isEmpty) {
            return 'Write something...';
          }
          return null;
        },
        hintText: 'Search...',
        suffix: Icons.search,
      ),
    );
  }

  Widget stackCircleAvatar(UserDataModel userDataModel) {
    return Stack(
      children: [
        CircleAvatar(
          backgroundImage: NetworkImage(
            userDataModel.profileImage!,
          ),
          radius: 30,
        ),
        Positioned(
          bottom: 8,
          right: 0,
          child: CircleAvatar(
            radius: 5.r,
            backgroundColor: Colors.green,
          ),
        ),
      ],
    );
  }

  Widget nameAndLastMessage(context,UserDataModel userDataModel) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${userDataModel.name}",
            style: Theme.of(context)
                .textTheme
                .headlineSmall!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10.h),
          Text(
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget timeOfLastMessage(context,) {
    return Text(
      "3:20 PM",
      style: Theme.of(context).textTheme.bodySmall,
    );
  }

  Widget userItemBuilder(context, UserDataModel userDataModel) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: InkWell(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (_)=>ChatScreen(userDataModel: userDataModel,)));
        },
        overlayColor: MaterialStateProperty.all(Colors.transparent),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            stackCircleAvatar(userDataModel),
            SizedBox(width: 10.w),
            nameAndLastMessage(context,userDataModel),
            SizedBox(width: 10.w),
            timeOfLastMessage(context),
          ],
        ),
      ),
    );
  }

  Widget addFriendsWidget(context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: Text(
                'add some friends',
                style: Theme.of(context).textTheme.displayMedium!.copyWith(
                  color: Colors.grey
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyFriendsChatsCubit, MyFriendsChatsStates>(
      builder: (BuildContext context, state) {
        var cubit = MyFriendsChatsCubit.get(context);
        return state is GetMyFriendsChatsDataLoadingState 
        ? const Center(child: AppLoading())
            : Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 10.0.w, vertical: 15.h),
                    child: Row(
                      children: [
                        leadingCircleAvatar(context),
                        SizedBox(width: 10.w),
                        searchFormField(),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.h),
                  cubit.myFriendsChats.isNotEmpty
                      ? Expanded(
                    child: ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) => userItemBuilder(context,cubit.myFriendsChats[index]),
                      separatorBuilder: (context, index) => const Divider(),
                      itemCount: cubit.myFriendsChats.length,
                    ),
                  )
                      : addFriendsWidget(context),
                ],
              );

      },
    );
  }
}
