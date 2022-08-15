import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/cubit.dart';
import 'package:social_app/layout/cubit/states.dart';
import 'package:social_app/shared/components.dart';
import 'package:social_app/shared/styles/styles.dart';
import 'package:social_app/shared/widgets/buildPostitem.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return SafeArea(
        child: SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          SizedBox(
            height: height * .34,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    imageUrl:
                        'https://ddragon.leagueoflegends.com/cdn/img/champion/splash/Zed_10.jpg',
                    height: height * .3,
                    maxHeightDiskCache: 150,
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
                ),
                Positioned(
                  bottom: 0,
                  left: width * .5 - 53,
                  child: const CircleAvatar(
                    radius: 48,
                    backgroundColor: Colors.grey,
                    child: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        backgroundImage: CachedNetworkImageProvider(
                          'https://www.francetvinfo.fr/pictures/MkDDU1PHloj2qc8qm-tfN8Jj52g/752x423/2019/04/11/john_wick_2_a.jpg',
                        ),
                        radius: 45),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: height * .01,
          ),
          Text(
            "Mahdi Ben Tamansourt",
            style: Theme.of(context).textTheme.headline5,
          ),
          SizedBox(
            height: height * .02,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              ProfileInfo(
                numbers: "123",
                string: "Followers",
              ),
              ProfileInfo(
                numbers: "2340",
                string: "Following",
              ),
              ProfileInfo(
                numbers: "3",
                string: "Posts",
              ),
            ],
          ),
          SizedBox(
            height: height * .02,
          ),
          buildProfileItem(
            height: height,
            prefixIcon: Icons.edit,
            suffixIcon: Icons.arrow_forward_ios_rounded,
            text: 'Edit Profile Information',
          ),
          SizedBox(
            height: height * .014,
          ),
          BlocConsumer<HomeCubit, HomeLayoutStates>(
            builder: (context, state) {
              var cubit = HomeCubit.get(context);
              return buildProfileItem(
                onTap: () {
                  if (user != null) {
                    cubit.logOutFromGoogle(context);
                  } else {
                    cubit.logOut(context);
                  }
                },
                height: height,
                prefixIcon: Icons.exit_to_app,
                suffixIcon: Icons.arrow_forward_ios_rounded,
                text: 'Exit From My Account ',
              );
            },
            listener: (context, state) {},
          ),
          SizedBox(
            height: height * .014,
          ),
          buildProfileItem(
            height: height,
            prefixIcon: Icons.post_add_rounded,
            suffixIcon: Icons.arrow_forward_ios_rounded,
            text: 'Show My Posts ',
          ),
          SizedBox(
            height: height * .014,
          ),
          buildProfileItem(
            height: height,
            prefixIcon: Icons.security_rounded,
            suffixIcon: Icons.arrow_forward_ios_rounded,
            text: 'Update Security Info ',
          ),
        ]),
      ),
    ));
  }
}

class buildProfileItem extends StatelessWidget {
  final VoidCallback? onTap;
  final IconData prefixIcon;
  final IconData suffixIcon;
  final String text;
  const buildProfileItem({
    Key? key,
    required this.height,
    required this.prefixIcon,
    required this.text,
    required this.suffixIcon,
    this.onTap,
  }) : super(key: key);

  final double height;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        height: height * 0.06,
        decoration: BoxDecoration(
          color: HexColor('#EEE9E3'),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          Icon(prefixIcon),
          Text(
            text,
            style: Theme.of(context).textTheme.subtitle1,
          ),
          Icon(suffixIcon),
        ]),
      ),
    );
  }
}

class ProfileInfo extends StatelessWidget {
  final String numbers;
  final String string;
  const ProfileInfo({
    Key? key,
    required this.numbers,
    required this.string,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          numbers,
          style: Theme.of(context).textTheme.headline6,
        ),
        Text(
          string,
          style: Theme.of(context).textTheme.subtitle1,
        )
      ],
    );
  }
}
