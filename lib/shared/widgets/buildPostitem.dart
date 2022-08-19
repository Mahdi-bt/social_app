import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:social_app/layout/cubit/cubit.dart';
import 'package:social_app/layout/cubit/states.dart';
import 'package:social_app/models/postModel.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

import '../styles/styles.dart';

class buildPostItem extends StatelessWidget {
  const buildPostItem({
    Key? key,
    required this.width,
    required this.height,
    required this.post,
    required this.index,
    required this.postUid,
  }) : super(key: key);
  final PostModel post;
  final double width;
  final double height;
  final String postUid;
  final int index;

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
            IconButton(
              padding: const EdgeInsets.all(0),
              icon: const Icon(
                IconBroken.Message,
                size: 28,
              ),
              onPressed: () {},
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
