import 'package:chat_app/application_layer/constants/app_colors.dart';
import 'package:chat_app/presentation_layer/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'home_layout/home_cubit/cubit.dart';
import 'home_layout/home_cubit/states.dart';

class MyContactsScreen extends StatelessWidget {
  const MyContactsScreen({
    super.key,
  });

  Widget reLoadActionButton(HomeCubit cubit) {
    return IconButton(
        onPressed: () {
          getMyContactsHaveAccounts(cubit);
        },
        icon: const Icon(
          Icons.refresh,
        )
    );
  }

  AppBar appBar(context, cubit) {
    return AppBar(
      title: Text(
        'Users',
        style: Theme
            .of(context)
            .textTheme
            .displayMedium!
            .copyWith(color: AppColors.firstColor),
      ),
      systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent),
      actions: [
        reLoadActionButton(cubit),
      ],
    );
  }

  void getMyContactsHaveAccounts(HomeCubit cubit) {
    cubit.getAppAllUsersPhoneNumber().then((value) =>
    {
      cubit.getContacts().then((value) {
        cubit.filterContacts(
            cubit.contacts!, cubit.allAppUsersPhoneNumbers);
      })
    });
  }

  Widget listTileItemBuilder(Contact contact) {
    return ListTile(
        leading: CircleAvatar(
          child: Text(contact.displayName!.substring(0, 1)),
        ),
        title: Text(contact.displayName ?? ''),
        subtitle: Text(contact.phones!.isNotEmpty
            ? contact.phones!.first.value!
            : ''),
        enabled: true,
        selected: true,
        trailing: chatIconButton(contact)
    );
  }

  Widget chatIconButton(Contact contact) {
    return BlocBuilder<HomeCubit,HomeStates>(
      builder: (BuildContext context, state) {
        var cubit=HomeCubit.get(context);
        return IconButton(
          onPressed: () {
            cubit.addFriend(contact.phones!.first.value!).then((value) {
              Navigator.pop(context);
            });
          },
          icon: const Icon(
            Icons.chat,
          ),
        );
      },
    );
  }

  Widget inviteFriendsWidget(context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Text(
            'invite your friends',
            style: Theme.of(context).textTheme.displayMedium!.copyWith(
                color: Colors.grey
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeStates>(
      builder: (BuildContext context, state) {
        HomeCubit cubit = HomeCubit.get(context);
        if (cubit.allAppUsersPhoneNumbers.isEmpty) {
          getMyContactsHaveAccounts(cubit);
        }
        return Scaffold(
            appBar: appBar(context, cubit),
            body: cubit.allAppUsersPhoneNumbers.isEmpty
                ? const Center(child: AppLoading())
                : cubit.filteredContactsHaveAccount.isNotEmpty
                ? ListView.builder(
              itemCount: cubit.filteredContactsHaveAccount.length,
              itemBuilder: (BuildContext context, int index) {
                Contact contact =
                cubit.filteredContactsHaveAccount[index];
                return listTileItemBuilder(contact);
              },
            )
                : inviteFriendsWidget(context)
        );
      },
    );
  }
}
