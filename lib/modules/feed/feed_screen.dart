import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/cubit.dart';
import 'package:social_app/layout/cubit/states.dart';
import 'package:social_app/modules/new_post/new_post_screen.dart';
import 'package:social_app/shared/styles/styles.dart';

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
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  colors: [
                    HexColor('#22CCFD'),
                    HexColor('#42A4FB'),
                    HexColor('#7664FB'),
                    HexColor('#8AB4F8'),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                      blurRadius: 7,
                      color: Colors.grey.shade400,
                      offset: const Offset(0, 5))
                ],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BlocBuilder<HomeCubit, HomeLayoutStates>(
                    builder: (context, state) {
                      var cubit = HomeCubit.get(context);
                      return IconButton(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(28))),
                            builder: (context) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 10),
                                height: height * .28,
                                child: Column(
                                  children: [
                                    Text(
                                      'Sort Feed By: ',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6!
                                          .copyWith(
                                            color: Colors.black,
                                          ),
                                    ),
                                    Expanded(
                                      child: ListTile(
                                        title: const Text('All'),
                                        leading: Radio<SortType>(
                                          value: SortType.all,
                                          groupValue: cubit.sortType,
                                          onChanged: (SortType? value) =>
                                              cubit.changeSortType(value),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: ListTile(
                                        title: const Text(
                                            'Only Follwing Users Posts'),
                                        leading: Radio<SortType>(
                                          value: SortType.onlyfollwing,
                                          groupValue: cubit.sortType,
                                          onChanged: (SortType? value) =>
                                              cubit.changeSortType(value),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: ListTile(
                                        title: const Text('Trending Posts'),
                                        leading: Radio<SortType>(
                                          value: SortType.popular,
                                          groupValue: cubit.sortType,
                                          onChanged: (SortType? value) =>
                                              cubit.changeSortType(value),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        icon: const Icon(
                          Icons.sort_rounded,
                          color: Colors.white,
                        ),
                      );
                    },
                  ),
                  Text(
                    'Feeds',
                    style: Theme.of(context).textTheme.headline5!.copyWith(
                          color: Colors.white,
                          fontSize: 28,
                        ),
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
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ],
              ),
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
                    itemBuilder: (_, index) => buildPostItem(
                          width: width,
                          height: height,
                          post: cubit.posts[index],
                          postUid: cubit.postsUid[index],
                          index: index,
                          newContext: context,
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
