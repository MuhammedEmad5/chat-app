import 'dart:io';
import 'package:chat_app/application_layer/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:photo_view/photo_view.dart';

import '../screens/my_profile/my_profile_cubit/cubit.dart';
import '../screens/my_profile/my_profile_cubit/states.dart';


class NetworkPhotoView extends StatelessWidget {
  const NetworkPhotoView({Key? key, required this.imageUrl}) : super(key: key);
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: PhotoView(
        imageProvider: NetworkImage(imageUrl),
        maxScale: PhotoViewComputedScale.contained * 2.0,
        minScale: PhotoViewComputedScale.contained * 1,
      ),
    );
  }
}

class FilePhotoView extends StatelessWidget {
  const FilePhotoView({Key? key, required this.imageFile}) : super(key: key);

  final File imageFile;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => MyProfileCubit(),
      child: BlocBuilder<MyProfileCubit, MyProfileStates>(
        builder: (BuildContext context, state) {
          MyProfileCubit cubit = MyProfileCubit.get(context);
          return SafeArea(
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                PhotoView(
                  imageProvider: FileImage(imageFile),
                  maxScale: PhotoViewComputedScale.contained * 2.0,
                  minScale: PhotoViewComputedScale.contained * 1,
                ),
                IconButton(
                  onPressed: () {
                    cubit.deletePickedImage().then((value) {
                      Navigator.pop(context);
                      cubit.getUserData();
                    });
                  },
                  icon: Icon(
                    Icons.delete,
                    size: 30.sp,
                    color: AppColors.white,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
