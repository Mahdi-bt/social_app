import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:social_app/shared/local/CacheHelper.dart';
import 'package:social_app/shared/widgets/widgets.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({Key? key}) : super(key: key);

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  var boardController = PageController();
  bool isLast = false;
  List<String> image_path = [
    "assets/images/onboard_1.png",
    "assets/images/onboard_2.png",
    "assets/images/onboard_3.png",
  ];

  List<String> onBoardingText = [
    "Get to Know your croworkers",
    "Reach out to anymore at anytime",
    "we dont' belive in cubicles",
  ];

  List<String> onBoardingTitle = [
    "Community",
    "Stay in Touch",
    "Personal Desk Space",
  ];
  int index = 0;
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(children: [
            Expanded(
              child: PageView.builder(
                controller: boardController,
                onPageChanged: (value) {
                  print(value);
                  if (index == 2) {
                    setState(() {
                      index = value;
                      isLast = true;
                    });
                  } else {
                    setState(() {
                      index = value;
                      isLast = false;
                    });
                  }
                },
                scrollDirection: Axis.horizontal,
                itemCount: 3,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Image.asset(
                        image_path[index],
                        height: height * .4,
                      ),
                      Text(
                        onBoardingTitle[index],
                        style: Theme.of(context)
                            .textTheme
                            .headline4!
                            .copyWith(color: Colors.black),
                      ),
                      Text(
                        onBoardingText[index],
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                    ],
                  );
                },
              ),
            ),
            SmoothPageIndicator(
              controller: boardController,
              effect: const ExpandingDotsEffect(
                dotColor: Colors.grey,
                activeDotColor: Colors.blue,
                dotHeight: 10,
                expansionFactor: 4,
                dotWidth: 10,
                spacing: 5.0,
              ),
              count: 3,
            ),
            SizedBox(
              height: height * .1,
            ),
            CustomButton(
                text: isLast ? 'GetStarted' : 'Next',
                color: '#478AE5',
                height: height * .07,
                onTap: () async {
                  if (isLast) {
                    CacheHelper.sharedPreferences
                        .setBool('onBoard', false)
                        .then((value) {
                      Navigator.of(context).pushReplacementNamed('/login');
                    });
                  } else {
                    boardController.nextPage(
                      duration: const Duration(
                        milliseconds: 750,
                      ),
                      curve: Curves.fastLinearToSlowEaseIn,
                    );
                  }
                },
                width: width),
            SizedBox(
              height: height * .01,
            ),
            TextButton(
                onPressed: () async {
                  CacheHelper.sharedPreferences
                      .setBool('onBoard', false)
                      .then((value) {
                    Navigator.of(context).pushReplacementNamed('/login');
                  });
                },
                child: Text('Skip The Tour',
                    style: Theme.of(context).textTheme.subtitle1))
          ]),
        ),
      ),
    );
  }
}
