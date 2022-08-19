import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/cubit.dart';
import 'package:social_app/layout/cubit/states.dart';
import 'package:social_app/modules/new_post/new_post_screen.dart';

import '../../shared/widgets/buildPostitem.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.height;
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: width * .02,
            vertical: height * .02,
          ),
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BlocBuilder<HomeCubit, HomeLayoutStates>(
                  builder: (context, state) => CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(
                      HomeCubit.get(context).currentUser!.profilePic,
                    ),
                  ),
                ),
                Text(
                  'Feeds',
                  style: Theme.of(context)
                      .textTheme
                      .headline4!
                      .copyWith(color: Colors.black),
                ),
                IconButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) {
                        return BlocProvider.value(
                          value: BlocProvider.of<HomeCubit>(context),
                          child: NewPostScreen(),
                        );
                      },
                    ),
                  ),
                  icon: const Icon(
                    Icons.add_circle_rounded,
                    color: Colors.black45,
                    size: 30,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: height * .03,
            ),
            BlocBuilder<HomeCubit, HomeLayoutStates>(
              builder: (context, state) {
                var cubit = HomeCubit.get(context);
                return ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) => buildPostItem(
                          width: width,
                          height: height,
                          post: cubit.posts[index],
                          postUid: cubit.postsUid[index],
                          index: index,
                        ),
                    separatorBuilder: (context, index) => SizedBox(
                          height: height * .02,
                        ),
                    itemCount: cubit.posts.length);
              },
            )
          ]),
        ),
      ),
    );
  }
}
