import 'package:chat_app/presentation_layer/screens/my_contact_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application_layer/constants/app_colors.dart';
import 'home_cubit/cubit.dart';
import 'home_cubit/states.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  BoxDecoration bottomNavigationBarContainerDecoration() {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppColors.firstColor,
          AppColors.secondColor,
        ],
        stops: const [0.4, 1.0],
      ),
    );
  }

  List<BottomNavigationBarItem> bottomNavigationBarItems() {
    return const [
      BottomNavigationBarItem(
        icon: Icon(Icons.chat),
        label: 'Chats',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.history),
        label: 'Status',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.phone),
        label: 'Calls',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (BuildContext context, state) {},
      builder: (BuildContext context, Object? state) {
        HomeCubit cubit = HomeCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            toolbarHeight: 0.0,
          ),
          body: cubit.homeScreens[cubit.selectedIndex],
          bottomNavigationBar: Container(
            decoration: bottomNavigationBarContainerDecoration(),
            child: BottomNavigationBar(
              currentIndex: cubit.selectedIndex,
              onTap: (index) {
                cubit.changeNavBar(index);
              },
              items: bottomNavigationBarItems(),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const MyContactsScreen(),
                ),
              );
            },
            child: const Icon(
              Icons.chat_outlined,
            ),
          ),
        );
      },
    );
  }
}
