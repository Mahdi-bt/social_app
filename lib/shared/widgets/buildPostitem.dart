import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:social_app/layout/cubit/cubit.dart';
import 'package:social_app/layout/cubit/states.dart';
import 'package:social_app/models/commentModel.dart';
import 'package:social_app/models/postModel.dart';
import 'package:social_app/modules/pdfViewr/pdf_view.dart';
import 'package:social_app/modules/settings/update_posts.dart';
import 'package:social_app/shared/styles/icon_broken.dart';
import 'package:social_app/shared/widgets/widgets.dart';

import '../styles/styles.dart';

class buildPostItem extends StatefulWidget {
  const buildPostItem({
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

  @override
  State<buildPostItem> createState() => _buildPostItemState();
}

class _buildPostItemState extends State<buildPostItem>
    with TickerProviderStateMixin {
  TextEditingController myController = TextEditingController();

  late AnimationController bookMarkController;
  late AnimationController heartController;
  @override
  void initState() {
    super.initState();
    bookMarkController = AnimationController(
      vsync: this,
      duration: const Duration(
        seconds: 2,
      ),
      value: HomeCubit.get(context).savedPostUid.contains(widget.postUid)
          ? 1.0
          : 0.0,
    );
    heartController = AnimationController(
      vsync: this,
      duration: const Duration(
        seconds: 2,
      ),
      value: HomeCubit.get(context).userLikesUid.contains(widget.postUid)
          ? 1.0
          : 0.0,
    );
  }

  @override
  void dispose() {
    super.dispose();
    bookMarkController.dispose();
    heartController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              blurRadius: 5,
              color: Colors.grey.shade400,
              offset: const Offset(0, 3))
        ],
        borderRadius: BorderRadius.circular(
          20,
        ),
        color: HexColor('#EFF3F5'),
      ),
      padding: EdgeInsets.symmetric(
          horizontal: widget.width * .02, vertical: widget.height * .02),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: widget.post.posterPhotoUrl,
                height: widget.height * .06,
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
              width: widget.width * .02,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.post.posterName,
                  style: Theme.of(context).textTheme.headline6!.copyWith(
                        color: Colors.black,
                      ),
                ),
                Text(
                  widget.post.postTime,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ],
            ),
            const Spacer(),
            if (widget.post.posterUid !=
                HomeCubit.get(context).currentUser!.uid)
              HomeCubit.get(context)
                      .followingUsers
                      .contains(widget.post.posterUid)
                  ? TextButton(
                      onPressed: () async => await HomeCubit.get(context)
                          .unfllowUser(userId: widget.post.posterUid),
                      child: Row(
                        children: const [
                          Text('Followed'),
                          Icon(
                            Icons.check,
                            size: 20,
                            color: Colors.lightBlue,
                          ),
                        ],
                      ),
                    )
                  : TextButton(
                      onPressed: () async => await HomeCubit.get(context)
                          .followPerson(userId: widget.post.posterUid),
                      child: Text(
                        'Follow',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),
            IconButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return BlocProvider.value(
                      value: BlocProvider.of<HomeCubit>(widget.newContext),
                      child: BlocConsumer<HomeCubit, HomeLayoutStates>(
                        listener: (context, state) {
                          if (state is HomeDeletePostSuccesState) {
                            Navigator.pop(context);
                          }
                        },
                        builder: (context, state) {
                          return SizedBox(
                            height: widget.post.posterUid ==
                                    HomeCubit.get(widget.newContext)
                                        .currentUser!
                                        .uid
                                ? widget.height * .18
                                : widget.height * .1,
                            child: Column(children: [
                              widget.post.posterUid ==
                                      HomeCubit.get(widget.newContext)
                                          .currentUser!
                                          .uid
                                  ? buildEditPostItem(
                                      width: widget.width,
                                      context: context,
                                      function: () async {
                                        await HomeCubit.get(context).deletePost(
                                            postUid: widget.postUid,
                                            index: widget.index);
                                      },
                                      height: widget.height,
                                      icon: Icons.delete_forever_rounded,
                                      text: 'Delete This Post',
                                      color: Colors.red)
                                  : const SizedBox(),
                              widget.post.posterUid ==
                                      HomeCubit.get(widget.newContext)
                                          .currentUser!
                                          .uid
                                  ? buildEditPostItem(
                                      function: () {
                                        Navigator.pop(context);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) {
                                              return BlocProvider.value(
                                                value:
                                                    BlocProvider.of<HomeCubit>(
                                                        context),
                                                child: UpdatePostScreen(
                                                  post: widget.post,
                                                  postId: widget.postUid,
                                                ),
                                              );
                                            },
                                          ),
                                        );
                                      },
                                      context: context,
                                      width: widget.width,
                                      height: widget.height,
                                      icon: Icons.edit,
                                      text: 'Update This Post',
                                      color: Colors.blue,
                                    )
                                  : const SizedBox(),
                              widget.post.posterUid !=
                                      HomeCubit.get(widget.newContext)
                                          .currentUser!
                                          .uid
                                  ? buildEditPostItem(
                                      function: () {},
                                      context: context,
                                      width: widget.width,
                                      height: widget.height,
                                      icon: Icons.report,
                                      text: 'Report This Post',
                                      color: Colors.grey,
                                    )
                                  : const SizedBox(),
                            ]),
                          );
                        },
                      ),
                    );
                  },
                );
              },
              icon: const Icon(Icons.more_vert_rounded),
            ),
          ],
        ),
        SizedBox(
          height: widget.height * .02,
        ),
        widget.post.mediaUrl != ""
            ? ClipRRect(
                borderRadius: BorderRadius.circular(
                  14,
                ),
                child: CachedNetworkImage(
                  imageUrl: widget.post.mediaUrl,
                  height: widget.height * .3,
                  width: widget.width,
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
        widget.post.pdfUrl != ""
            ? InkWell(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PdfView(url: widget.post.pdfUrl),
                    )),
                child: Container(
                  height: widget.height * .09,
                  width: widget.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      color: HexColor('#CED6DC'),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.shade400,
                            blurRadius: 7,
                            offset: const Offset(0, 5))
                      ]),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Image.asset(
                          'assets/images/file.png',
                          height: widget.height * .07,
                        ),
                        Text(
                          'Pdf File Tap to Preview it',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ]),
                ),
              )
            : const SizedBox(),
        SizedBox(height: widget.height * .005),
        Row(
          children: [
            BlocBuilder<HomeCubit, HomeLayoutStates>(
              builder: (context, state) {
                return GestureDetector(
                  onTap: () {
                    if (!HomeCubit.get(context)
                        .userLikesUid
                        .contains(widget.postUid)) {
                      HomeCubit.get(context)
                          .likePost(postId: widget.postUid)
                          .then((value) {
                        heartController.forward();
                      });
                    } else {
                      HomeCubit.get(context)
                          .removeLike(postUid: widget.postUid)
                          .then((value) {
                        heartController.reverse();
                      });
                    }
                  },
                  child: Lottie.asset(
                    'assets/images/heart_animation.json',
                    width: widget.width * .08,
                    height: widget.height * .09,
                    controller: heartController,
                  ),
                );
              },
            ),
            BlocBuilder<HomeCubit, HomeLayoutStates>(
              builder: (context, state) {
                var cubit = HomeCubit.get(context);
                return Text(
                  HomeCubit.get(context).postsLikes[widget.postUid]!.isEmpty
                      ? "0"
                      : HomeCubit.get(context)
                          .postsLikes[widget.postUid]!
                          .length
                          .toString(),
                  style: cubit.postsLikes[widget.postUid]!
                          .contains(cubit.currentUser!.uid)
                      ? Theme.of(context)
                          .textTheme
                          .subtitle1!
                          .copyWith(color: Colors.blueAccent, fontSize: 20)
                      : Theme.of(context).textTheme.subtitle1,
                );
              },
            ),
            BlocBuilder<HomeCubit, HomeLayoutStates>(
              builder: (context, state) {
                return IconButton(
                  padding: const EdgeInsets.all(0),
                  icon: Icon(
                    IconBroken.Message,
                    color: Colors.grey.shade500,
                    size: 28,
                  ),
                  onPressed: () async {
                    await HomeCubit.get(context)
                        .getUsersCommentList(Uid: widget.postUid)
                        .then((value) {});
                    showModalBottomSheet(
                      context: context,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(28),
                        ),
                      ),
                      isScrollControlled: true,
                      useRootNavigator: true,
                      builder: (context) {
                        return BlocProvider.value(
                          value: BlocProvider.of<HomeCubit>(widget.newContext),
                          child: BlocBuilder<HomeCubit, HomeLayoutStates>(
                            builder: (context, state) {
                              var cubit = HomeCubit.get(context);
                              List<CommentModel> comment =
                                  cubit.postsComment[widget.postUid]!;

                              return Container(
                                height: widget.height * .9,
                                width: widget.width,
                                padding: EdgeInsets.symmetric(
                                    horizontal: widget.width * .01,
                                    vertical: widget.height * .03),
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: comment.isEmpty
                                          ? const Text('No Comment yet')
                                          : ListView.separated(
                                              itemBuilder: (context, index) {
                                                return Row(
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      child: CachedNetworkImage(
                                                        imageUrl: comment[index]
                                                            .commentUserPic,
                                                        height:
                                                            widget.height * .06,
                                                        maxHeightDiskCache: 75,
                                                        key: UniqueKey(),
                                                        placeholder:
                                                            (context, url) =>
                                                                Container(
                                                          color: Colors.black12,
                                                        ),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            Container(
                                                          color: Colors.black12,
                                                          child: const Icon(
                                                              Icons.report),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: widget.width * .02,
                                                    ),
                                                    Expanded(
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          color: HexColor(
                                                              '#EFEFEF'),
                                                        ),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              cubit
                                                                  .commentUsers[
                                                                      index]
                                                                  .userName,
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .headline6!
                                                                  .copyWith(
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                            Text(
                                                              comment[index]
                                                                  .commentText,
                                                              style: Theme.of(
                                                                      context)
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
                                                      icon: const Icon(Icons
                                                          .more_vert_rounded),
                                                    ),
                                                  ],
                                                );
                                              },
                                              separatorBuilder:
                                                  (context, index) => SizedBox(
                                                      height:
                                                          widget.height * .03),
                                              itemCount: cubit
                                                  .postsComment[widget.postUid]!
                                                  .length,
                                              shrinkWrap: true,
                                              physics:
                                                  const BouncingScrollPhysics(),
                                            ),
                                    ),
                                    SizedBox(
                                      height: widget.height * .01,
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
                                          SizedBox(
                                            width: widget.width * 0.015,
                                          ),
                                          Container(
                                            decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.lightBlue),
                                            child: IconButton(
                                              onPressed: () async {
                                                await cubit.commentPost(
                                                    postUid: widget.postUid,
                                                    posterUid:
                                                        widget.post.posterUid,
                                                    commentText:
                                                        myController.text);
                                                myController.clear();
                                              },
                                              icon: const Icon(
                                                Icons.send_rounded,
                                                color: Colors.white,
                                              ),
                                            ),
                                          )
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
                color: Colors.lightBlue,
                size: 28,
              ),
              onPressed: () {},
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {
                if (!HomeCubit.get(context)
                    .savedPostUid
                    .contains(widget.postUid)) {
                  HomeCubit.get(context)
                      .bookMarkPost(postUid: widget.postUid)
                      .then((value) {
                    bookMarkController.forward();
                  });
                } else {
                  HomeCubit.get(context)
                      .removeBookMarkedPost(postUid: widget.postUid)
                      .then((value) {
                    bookMarkController.reverse();
                  });
                }
              },
              child: Lottie.asset('assets/images/772-bookmark-animation.json',
                  height: 55, controller: bookMarkController, reverse: false),
            )
          ],
        ),
        Text(
          widget.post.postTitle,
          style: Theme.of(context).textTheme.caption!.copyWith(
                overflow: TextOverflow.ellipsis,
                fontSize: 16,
              ),
          maxLines: 2,
        ),
        SizedBox(
          height: widget.height * .01,
        ),
        Container(
          height: widget.height * .001,
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
                width: widget.width * .01,
              ),
              Text(
                widget.post.postComment.toString(),
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

  Widget buildEditPostItem(
          {required width,
          required height,
          required icon,
          required text,
          required function,
          required color,
          required BuildContext context}) =>
      InkWell(
        onTap: function,
        child: Container(
          margin: EdgeInsets.symmetric(
              horizontal: width * .07, vertical: height * .01),
          height: height * .065,
          decoration: BoxDecoration(
            color: HexColor('#E1E1E1'),
            borderRadius: BorderRadius.circular(20),
          ),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            Icon(
              icon,
              color: color,
              size: 26,
            ),
            Text(text,
                style: Theme.of(context)
                    .textTheme
                    .headline6!
                    .copyWith(color: Colors.black)),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 26,
            ),
          ]),
        ),
      );
}
