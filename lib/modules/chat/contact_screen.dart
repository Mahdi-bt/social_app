import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/cubit.dart';
import 'package:social_app/layout/cubit/states.dart';
import 'package:social_app/layout/home_layout.dart';

import '../../shared/styles/styles.dart';
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
        Container(
          margin: EdgeInsets.symmetric(
            horizontal: width * .01,
            vertical: height * .02,
          ),
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
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.sort_rounded,
                  color: Colors.white,
                ),
              ),
              Text(
                'Contacts',
                style: Theme.of(context)
                    .textTheme
                    .headline5!
                    .copyWith(color: Colors.white),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.search_rounded,
                  color: Colors.white,
                ),
              ),
            ],
          ),
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
