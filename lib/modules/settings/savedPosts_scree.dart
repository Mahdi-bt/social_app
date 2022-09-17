import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../layout/cubit/cubit.dart';
import '../../layout/cubit/states.dart';
import '../../shared/widgets/buildPostitem.dart';

class SavedPostScreen extends StatelessWidget {
  const SavedPostScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Saved Posts',
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
          height: height * .01,
        ),
        Expanded(
          child: BlocBuilder<HomeCubit, HomeLayoutStates>(
            builder: (context, state) {
              var cubit = HomeCubit.get(context);
              return cubit.savedPost.isEmpty
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
                          horizontal: width * .03, vertical: height * .01),
                      itemBuilder: (context, index) {
                        return buildPostItem(
                          width: width,
                          height: height,
                          post: cubit.savedPost[cubit.savedPostUid[index]]!,
                          index: index,
                          postUid: cubit.savedPostUid[index],
                          newContext: context,
                        );
                      },
                      separatorBuilder: (context, index) => SizedBox(
                            height: height * .01,
                          ),
                      itemCount: cubit.savedPost.length);
            },
          ),
        ),
      ]),
    );
  }
}
