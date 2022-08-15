import 'package:flutter/material.dart';
import 'package:social_app/shared/styles/styles.dart';

import '../../shared/styles/icon_broken.dart';

class NotificationScreen extends StatelessWidget {
  NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    double height = MediaQuery.of(context).size.height;
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
              'Notification',
              style: Theme.of(context).textTheme.headline5,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: CircleAvatar(
                radius: 18,
                child: Center(
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () {},
                    icon: const Icon(Icons.delete_rounded),
                  ),
                ),
              ),
            ),
          ],
        ),
        ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) => buildNotificationitem(
                width: width,
                iconColors: iconColors[index],
                icon: notfication_icons[index],
                notificationText: notification_text[index]),
            separatorBuilder: (context, index) => Sperator(width: width),
            itemCount: 4)
      ]),
    ));
  }

  List<String> notification_text = [
    "Mouti Ben Yahia Liked your Post",
    "Mahdi Ben Yahia Comment your Post",
    "Omar Ben Yahia Report your Post",
    "Mohamed Ben Yahia Accept your Invitation"
  ];
  List<Color> iconColors = [
    Colors.red,
    Colors.grey,
    Colors.red,
    Colors.blue,
  ];
  List<IconData> notfication_icons = [
    IconBroken.Heart,
    Icons.comment,
    Icons.report,
    Icons.verified_rounded,
  ];
}

class buildNotificationitem extends StatelessWidget {
  final IconData icon;
  final String notificationText;
  final Color iconColors;
  const buildNotificationitem(
      {Key? key,
      required this.width,
      required this.notificationText,
      required this.icon,
      required this.iconColors})
      : super(key: key);

  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: HexColor('#EBF1FE'),
            child: Icon(
              icon,
              color: iconColors,
            ),
          ),
          SizedBox(
            width: width * .05,
          ),
          Expanded(
            child: Text(
              notificationText,
              style: Theme.of(context).textTheme.headline6,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class Sperator extends StatelessWidget {
  const Sperator({
    Key? key,
    required this.width,
  }) : super(key: key);

  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 2,
      color: Colors.grey[100],
      margin: EdgeInsets.symmetric(horizontal: width * 0.07),
    );
  }
}
