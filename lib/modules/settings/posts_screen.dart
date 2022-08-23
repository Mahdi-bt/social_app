import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/states.dart';
import 'package:social_app/shared/widgets/buildPostitem.dart';

import '../../layout/cubit/cubit.dart';

class MyPostsScreen extends StatelessWidget {
  const MyPostsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Posts',
          style: Theme.of(context).textTheme.headline5!.copyWith(
                color: Colors.black,
              ),
        ),
        centerTitle: true,
      ),
      body: Column(children: [
        Container(
          height: 1.0,
          color: Colors.grey.shade100,
        ),
        SizedBox(
          height: screenHeight * .01,
        ),
        Expanded(
          child: BlocBuilder<HomeCubit, HomeLayoutStates>(
            builder: (context, state) {
              var cubit = HomeCubit.get(context);
              return cubit.myPosts.isEmpty
                  ? Center(
                      child: Text(
                        'There is no Post Yet',
                        style: Theme.of(context).textTheme.headline6!.copyWith(
                              color: Colors.black,
                            ),
                      ),
                    )
                  : ListView.separated(
                      padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * .03,
                          vertical: screenHeight * .01),
                      itemBuilder: (context, index) {
                        return buildPostItem(
                          width: screenWidth,
                          height: screenHeight,
                          post: cubit.myPosts[index],
                          index: index,
                          postUid: cubit.myPostUid[index],
                          newContext: context,
                        );
                      },
                      separatorBuilder: (context, index) => SizedBox(
                            height: screenHeight * .01,
                          ),
                      itemCount: cubit.myPostUid.length);
            },
          ),
        ),
      ]),
    );
  }
}
