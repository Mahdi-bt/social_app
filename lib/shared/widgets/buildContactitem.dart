import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../styles/styles.dart';

class buildContactItem extends StatelessWidget {
  const buildContactItem({
    Key? key,
    required this.width,
    required this.height,
  }) : super(key: key);

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: width * .02,
        vertical: height * .01,
      ),
      height: height * .14,
      margin: EdgeInsets.symmetric(
        horizontal: width * .02,
        vertical: height * .01,
      ),
      decoration: BoxDecoration(
          color: HexColor('##F7F7F7'),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.15),
              blurRadius: 2,
              offset: const Offset(0, 5),
            ),
          ]),
      child: Row(children: [
        CircleAvatar(
            radius: 33,
            backgroundColor: Colors.grey,
            child: Stack(
              children: [
                const Align(
                  alignment: Alignment.center,
                  child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      backgroundImage: CachedNetworkImageProvider(
                        'https://www.francetvinfo.fr/pictures/MkDDU1PHloj2qc8qm-tfN8Jj52g/752x423/2019/04/11/john_wick_2_a.jpg',
                      ),
                      radius: 30),
                ),
                Align(
                  alignment: AlignmentDirectional.bottomEnd,
                  child: Container(
                    height: height * 0.02,
                    width: width * 0.02,
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(30)),
                  ),
                )
              ],
            )),
        SizedBox(
          width: width * .02,
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Mahdi BT',
                style: Theme.of(context).textTheme.headline6!.copyWith(
                      color: Colors.black,
                    ),
              ),
              Text(
                'hello how are u there  are u doing ok Tokay or u have somtheing else to do',
                style: Theme.of(context).textTheme.bodyText1!.copyWith(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        Text(
          '9:34PM',
          style: Theme.of(context).textTheme.subtitle1,
        ),
      ]),
    );
  }
}
