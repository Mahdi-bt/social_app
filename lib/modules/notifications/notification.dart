import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/cubit.dart';
import 'package:social_app/layout/cubit/states.dart';
import 'package:social_app/models/notificationModel.dart';
import 'package:social_app/shared/components.dart';
import 'package:social_app/shared/styles/styles.dart';

import '../../shared/styles/icon_broken.dart';

class NotificationScreen extends StatelessWidget {
  NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    double height = MediaQuery.of(context).size.height;
    return Builder(builder: (context) {
      var cubit = HomeCubit.get(context);
      cubit.getNotification();

      return BlocConsumer<HomeCubit, HomeLayoutStates>(
        listener: (context, state) {
          if (state is HomeDeleteUserNotificationSuccesState) {
            showToast(
              text: 'Notification delete Succsfuly',
              state: ToastStates.SUCCESS,
            );
          }
          if (state is HomeDeleteUserNotificationFailedState) {
            showToast(
              text: 'Failed to delete Notification',
              state: ToastStates.ERROR,
            );
          }
        },
        builder: (context, state) {
          return SafeArea(
              child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.sort_rounded,
                  ),
                ),
                Text(
                  'Notification',
                  style: Theme.of(context).textTheme.headline5,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: CircleAvatar(
                    radius: 18,
                    child: Center(
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () {
                          cubit.deleteUserNotification();
                        },
                        icon: const Icon(Icons.delete_rounded),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: cubit.notification.isEmpty
                  ? Center(
                      child: Text(
                        'There is No Notification Yet',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) => buildNotificationitem(
                          width: width,
                          notificationModel: cubit.notification[index]),
                      separatorBuilder: (context, index) =>
                          Sperator(width: width),
                      itemCount: cubit.notification.length),
            )
          ]));
        },
      );
    });
  }
}

class buildNotificationitem extends StatelessWidget {
  final NotificationModel notificationModel;
  const buildNotificationitem(
      {Key? key, required this.width, required this.notificationModel})
      : super(key: key);

  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: HexColor('#EBF1FE'),
            child: Icon(
                notificationModel.type == "postLike"
                    ? IconBroken.Heart
                    : Icons.comment,
                color: notificationModel.type == "postLike"
                    ? Colors.red
                    : Colors.grey),
          ),
          SizedBox(
            width: width * .05,
          ),
          Expanded(
            child: Text(
              notificationModel.type == "postComment"
                  ? "${notificationModel.userName} comment your post"
                  : "${notificationModel.userName} like your post",
              style: Theme.of(context).textTheme.headline6,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class Sperator extends StatelessWidget {
  const Sperator({
    Key? key,
    required this.width,
  }) : super(key: key);

  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 2,
      color: Colors.grey[100],
      margin: EdgeInsets.symmetric(horizontal: width * 0.07),
    );
  }
}
