import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/cubit.dart';
import 'package:social_app/layout/cubit/states.dart';
import 'package:social_app/layout/home_layout.dart';

import '../../shared/widgets/buildContactitem.dart';

class ContactScrenn extends StatelessWidget {
  const ContactScrenn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.height;
    return SafeArea(
        child: SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
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
              'Contacts',
              style: Theme.of(context).textTheme.headline5,
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.search_rounded,
              ),
            ),
          ],
        ),
        BlocBuilder<HomeCubit, HomeLayoutStates>(
          builder: (context, state) {
            var cubit = HomeCubit.get(context);
            return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) => buildContactItem(
                      width: width,
                      height: height,
                      userModel: cubit.users[index],
                    ),
                separatorBuilder: (context, index) => SizedBox(
                      height: height * .001,
                    ),
                itemCount: cubit.users.length);
          },
        ),
      ]),
    ));
  }
}
