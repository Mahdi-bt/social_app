import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:social_app/layout/cubit/cubit.dart';
import 'package:social_app/layout/cubit/states.dart';
import 'package:social_app/models/commentModel.dart';
import 'package:social_app/models/postModel.dart';
import 'package:social_app/models/userModel.dart';
import 'package:social_app/shared/styles/icon_broken.dart';
import 'package:social_app/shared/widgets/widgets.dart';

import '../styles/styles.dart';

class buildPostItem extends StatelessWidget {
  buildPostItem({
    Key? key,
    required this.width,
    required this.height,
    required this.post,
    required this.index,
    required this.postUid,
    required this.newContext,
  }) : super(key: key);
  final PostModel post;
  final double width;
  final double height;
  final String postUid;
  final int index;
  final BuildContext newContext;
  TextEditingController myController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          20,
        ),
        color: HexColor('#EFF3F5'),
      ),
      padding:
          EdgeInsets.symmetric(horizontal: width * .02, vertical: height * .02),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: post.posterPhotoUrl,
                height: height * .06,
                maxHeightDiskCache: 75,
                key: UniqueKey(),
                placeholder: (context, url) => Container(
                  color: Colors.black12,
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.black12,
                  child: const Icon(Icons.report),
                ),
              ),
            ),
            SizedBox(
              width: width * .02,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.posterName,
                  style: Theme.of(context).textTheme.headline6!.copyWith(
                        color: Colors.black,
                      ),
                ),
                Text(
                  post.postTime,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ],
            ),
            const Spacer(),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.more_vert_rounded),
            ),
          ],
        ),
        SizedBox(
          height: height * .02,
        ),
        post.mediaUrl != ""
            ? ClipRRect(
                borderRadius: BorderRadius.circular(
                  14,
                ),
                child: CachedNetworkImage(
                  imageUrl: post.mediaUrl,
                  height: height * .3,
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
            : const SizedBox(),
        SizedBox(height: height * .005),
        Row(
          children: [
            BlocBuilder<HomeCubit, HomeLayoutStates>(
              builder: (context, state) {
                var cubit = HomeCubit.get(context);
                return IconButton(
                  icon: Icon(
                    IconBroken.Heart,
                    size: 28,
                    color: cubit.postsLikes[postUid]!
                            .contains(cubit.currentUser!.uid)
                        ? Colors.red
                        : Colors.grey,
                  ),
                  onPressed: () {
                    cubit.postsLikes[postUid]!.contains(cubit.currentUser!.uid)
                        ? cubit.removeLike(postUid: postUid)
                        : HomeCubit.get(context).likePost(postId: postUid);
                  },
                );
              },
            ),
            BlocBuilder<HomeCubit, HomeLayoutStates>(
              builder: (context, state) {
                var cubit = HomeCubit.get(context);
                return Text(
                  HomeCubit.get(context).postsLikes[postUid]!.isEmpty
                      ? "0"
                      : HomeCubit.get(context)
                          .postsLikes[postUid]!
                          .length
                          .toString(),
                  style: cubit.postsLikes[postUid]!
                          .contains(cubit.currentUser!.uid)
                      ? Theme.of(context)
                          .textTheme
                          .subtitle1!
                          .copyWith(color: Colors.blueAccent)
                      : Theme.of(context).textTheme.subtitle1,
                );
              },
            ),
            BlocBuilder<HomeCubit, HomeLayoutStates>(
              builder: (context, state) {
                return IconButton(
                  padding: const EdgeInsets.all(0),
                  icon: const Icon(
                    IconBroken.Message,
                    size: 28,
                  ),
                  onPressed: () async {
                    await HomeCubit.get(context)
                        .getUsersCommentList(Uid: postUid)
                        .then((value) {});
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      useRootNavigator: true,
                      builder: (context) {
                        return BlocProvider.value(
                          value: BlocProvider.of<HomeCubit>(newContext),
                          child: BlocBuilder<HomeCubit, HomeLayoutStates>(
                            builder: (context, state) {
                              var cubit = HomeCubit.get(context);
                              List<CommentModel>? comment =
                                  cubit.postsComment[postUid];

                              return Container(
                                height: height * .9,
                                width: width,
                                padding: EdgeInsets.symmetric(
                                    horizontal: width * .01,
                                    vertical: height * .03),
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: ListView.separated(
                                        itemBuilder: (context, index) {
                                          return Row(
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                child: CachedNetworkImage(
                                                  imageUrl: comment![index]
                                                      .commentUserPic,
                                                  height: height * .06,
                                                  maxHeightDiskCache: 75,
                                                  key: UniqueKey(),
                                                  placeholder: (context, url) =>
                                                      Container(
                                                    color: Colors.black12,
                                                  ),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          Container(
                                                    color: Colors.black12,
                                                    child: const Icon(
                                                        Icons.report),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: width * .02,
                                              ),
                                              Expanded(
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    color: HexColor('#EFEFEF'),
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        cubit
                                                            .commentUsers[index]
                                                            .userName,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .headline6!
                                                            .copyWith(
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                      Text(
                                                        comment[index]
                                                            .commentText,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyText1,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              const Spacer(),
                                              IconButton(
                                                onPressed: () {},
                                                icon: const Icon(
                                                    Icons.more_vert_rounded),
                                              ),
                                            ],
                                          );
                                        },
                                        separatorBuilder: (context, index) =>
                                            SizedBox(height: height * .03),
                                        itemCount:
                                            cubit.postsComment[postUid]!.length,
                                        shrinkWrap: true,
                                        physics: const BouncingScrollPhysics(),
                                      ),
                                    ),
                                    SizedBox(
                                      height: height * .01,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        bottom: MediaQuery.of(context)
                                            .viewInsets
                                            .bottom,
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: CustomTextFormField(
                                              prefixIcon: null,
                                              suffixIcon:
                                                  Icons.emoji_emotions_rounded,
                                              hintText:
                                                  'Enter your comment here',
                                              labelText: null,
                                              myController: myController,
                                            ),
                                          ),
                                          IconButton(
                                              onPressed: () async {
                                                await cubit.commentPost(
                                                    postUid: postUid,
                                                    commentText:
                                                        myController.text);
                                                myController.clear();
                                              },
                                              icon: const Icon(
                                                  Icons.send_rounded))
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
            IconButton(
              icon: const Icon(
                IconBroken.Send,
                size: 28,
              ),
              onPressed: () {},
            ),
            const Spacer(),
            IconButton(
              onPressed: () {},
              icon: SvgPicture.asset(
                'assets/images/bookmark-solid.svg',
                height: 26,
                color: Colors.black45,
              ),
            )
          ],
        ),
        Text(
          post.postTitle,
          style: Theme.of(context).textTheme.caption!.copyWith(
                overflow: TextOverflow.ellipsis,
                fontSize: 16,
              ),
          maxLines: 2,
        ),
        SizedBox(
          height: height * .01,
        ),
        Container(
          height: height * .001,
          width: double.infinity,
          color: Colors.grey[300],
        ),
        TextButton(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'View All Comment',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(
                width: width * .01,
              ),
              Text(
                post.postComment.toString(),
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: Colors.red),
              ),
            ],
          ),
          onPressed: () {},
        )
      ]),
    );
  }
}
