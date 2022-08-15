import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

import '../styles/styles.dart';

class buildPostItem extends StatelessWidget {
  const buildPostItem({
    Key? key,
    required this.width,
    required this.height,
  }) : super(key: key);

  final double width;
  final double height;

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
      height: height * .65,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl:
                    'https://images.pexels.com/photos/2379004/pexels-photo-2379004.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
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
                  'Mahdi Ben Tamansourt',
                  style: Theme.of(context).textTheme.headline6!.copyWith(
                        color: Colors.black,
                      ),
                ),
                Text(
                  'Software Enginner',
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
        ClipRRect(
          borderRadius: BorderRadius.circular(
            14,
          ),
          child: CachedNetworkImage(
            imageUrl:
                'https://cdn.pixabay.com/photo/2016/05/24/16/48/mountains-1412683__340.png',
            height: height * .3,
            maxHeightDiskCache: 75,
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
        SizedBox(height: height * .005),
        Row(
          children: [
            IconButton(
              icon: const Icon(
                IconBroken.Heart,
                size: 28,
              ),
              onPressed: () {},
            ),
            Text(
              '12K',
              style: Theme.of(context).textTheme.subtitle1,
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
          "Tanjiro",
          style: Theme.of(context).textTheme.headline6,
        ),
        Text(
          'is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s',
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
                '192',
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
