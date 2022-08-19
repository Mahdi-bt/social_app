import 'package:flutter/material.dart';
import 'package:social_app/layout/home_layout.dart';
import 'package:social_app/modules/feed/feed_screen.dart';
import 'package:social_app/modules/login/forget_password.dart';
import 'package:social_app/modules/login/login_screen.dart';
import 'package:social_app/modules/new_post/new_post_screen.dart';
import 'package:social_app/modules/onBoarding/onBoarding_screen.dart';
import 'package:social_app/modules/register/register_screen.dart';
import 'package:social_app/shared/animation/sizeAnimation.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    final args = routeSettings.arguments;
    switch (routeSettings.name) {
      case '/home':
        return SizeAnimationToLeft(
          page: HomeLayout(),
        );
      case '/login':
        return MaterialPageRoute(
          builder: (_) => LoginScreen(),
        );
      case '/onBoarding':
        return MaterialPageRoute(
          builder: (_) => const OnBoarding(),
        );

      case '/feed':
        return MaterialPageRoute(
          builder: (_) => const FeedScreen(),
        );
      case '/register':
        return SizeAnimationToLeft(
          page: RegisterScreen(),
        );
      case '/newpost':
        return SizeAnimationToLeft(
          page: NewPostScreen(),
        );
      case '/forgetPassword':
        return SizeAnimationToRight(page: ForgetPasswordScreen());
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: const Text('Error '),
        ),
        body: const Center(
          child: Text('There was an error'),
        ),
      ),
    );
  }
}
