import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/states.dart';
import 'package:social_app/models/chatModel.dart';
import 'package:social_app/models/userModel.dart';
import 'package:social_app/shared/styles/icon_broken.dart';
import 'package:social_app/shared/styles/styles.dart';

import '../../layout/cubit/cubit.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({Key? key, required this.chatUser}) : super(key: key);
  final UserModel chatUser;
  TextEditingController messageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Builder(
      builder: (context) {
        var cubit = HomeCubit.get(context);
        cubit.getMessages(reciverId: chatUser.uid);
        return Scaffold(
          appBar: AppBar(
            title: Row(children: [
              CircleAvatar(
                backgroundImage:
                    CachedNetworkImageProvider(chatUser.profilePic),
              ),
              SizedBox(
                width: screenWidth * .02,
              ),
              Text(
                chatUser.userName,
                style: Theme.of(context)
                    .textTheme
                    .headline5!
                    .copyWith(color: Colors.black),
              ),
            ]),
            actions: [
              IconButton(onPressed: () {}, icon: const Icon(IconBroken.Call)),
              IconButton(onPressed: () {}, icon: const Icon(IconBroken.Video))
            ],
          ),
          body: BlocBuilder<HomeCubit, HomeLayoutStates>(
            builder: (context, state) {
              var cubit = HomeCubit.get(context);
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(children: [
                  Expanded(
                    child: ListView.separated(
                        itemBuilder: (context, index) {
                          var message = cubit.chats[index];
                          if (message.senderId == cubit.currentUser!.uid) {
                            return buildMyMessage(
                                screenHeight: screenHeight * 0.013,
                                screenWidth: screenWidth * 0.02,
                                message: message,
                                context: context,
                                height: screenHeight,
                                width: screenWidth);
                          } else {
                            return buildMessage(
                              screenHeight: screenHeight * 0.013,
                              screenWidth: screenWidth * 0.02,
                              message: message,
                              context: context,
                            );
                          }
                        },
                        separatorBuilder: (context, index) => SizedBox(
                              height: screenHeight * 0.01,
                            ),
                        itemCount: cubit.chats.length),
                  ),
                  Row(
                    children: [
                      Container(
                        height: screenHeight * .069,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: HexColor('#ADC3D1'),
                        ),
                        child: MaterialButton(
                          onPressed: () async {
                            await cubit.pickMessageImage();
                          },
                          minWidth: 1.0,
                          child: const Icon(
                            Icons.attach_file_rounded,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: screenWidth * .01,
                      ),
                      Expanded(
                        child: Container(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.grey.shade400, width: 1.0),
                            borderRadius: BorderRadius.circular(
                              15,
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: messageController,
                                  decoration: const InputDecoration(
                                      contentPadding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      border: InputBorder.none,
                                      hintText: 'Enter your message here'),
                                ),
                              ),
                              Container(
                                height: screenHeight * .069,
                                color: Colors.lightBlue,
                                child: MaterialButton(
                                  onPressed: () {
                                    HomeCubit.get(context).sendMessage(
                                        reciverId: chatUser.uid,
                                        messageText: messageController.text);
                                    messageController.clear();
                                  },
                                  minWidth: 1.0,
                                  child: const Icon(
                                    IconBroken.Send,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                ]),
              );
            },
          ),
        );
      },
    );
  }

  Widget buildMessage(
          {required screenHeight,
          required screenWidth,
          required ChatModel message,
          context}) =>
      Align(
        alignment: AlignmentDirectional.centerStart,
        child: Container(
          padding: EdgeInsets.symmetric(
              vertical: screenHeight, horizontal: screenWidth),
          decoration: BoxDecoration(
            color: HexColor('#F5F8FE'),
            borderRadius: const BorderRadiusDirectional.only(
              topStart: Radius.circular(10),
              topEnd: Radius.circular(10),
              bottomEnd: Radius.circular(10),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                message.messageText,
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                message.dateTime,
                style: Theme.of(context).textTheme.caption,
              )
            ],
          ),
        ),
      );

  Widget buildMyMessage(
          {required screenHeight,
          required screenWidth,
          required ChatModel message,
          required height,
          context,
          required double width}) =>
      Align(
        alignment: AlignmentDirectional.centerEnd,
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: screenHeight,
            horizontal: screenWidth,
          ),
          decoration: BoxDecoration(
            color: HexColor('#D8E5FF'),
            borderRadius: const BorderRadiusDirectional.only(
              topStart: Radius.circular(10),
              topEnd: Radius.circular(10),
              bottomStart: Radius.circular(10),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                message.messageText,
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              SizedBox(
                height: height * 0.01,
              ),
              message.imageUrl != ""
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(
                        14,
                      ),
                      child: CachedNetworkImage(
                        imageUrl: message.imageUrl,
                        height: height * .25,
                        width: width * .8,
                        maxHeightDiskCache: 200,
                        fit: BoxFit.cover,
                        key: UniqueKey(),
                        placeholder: (context, url) => Container(
                          color: Colors.black12,
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.black12,
                          child: const Icon(Icons.report),
                        ),
                      ),
                    )
                  : SizedBox(),
              Text(
                message.dateTime,
                style: Theme.of(context).textTheme.caption,
              )
            ],
          ),
        ),
      );
}
