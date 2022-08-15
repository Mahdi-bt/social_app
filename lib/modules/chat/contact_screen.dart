import 'package:flutter/material.dart';

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
        ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) =>
                buildContactItem(width: width, height: height),
            separatorBuilder: (context, index) => SizedBox(
                  height: height * .001,
                ),
            itemCount: 8),
      ]),
    ));
  }
}
