import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/shared/bloc_observer.dart';
import 'package:social_app/shared/local/CacheHelper.dart';
import 'package:social_app/shared/router.dart';
import 'package:social_app/shared/styles/styles.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper.init();
  await Firebase.initializeApp();

  String widgetToStart;
  if (CacheHelper.sharedPreferences.getBool('onBoard') != null &&
      CacheHelper.sharedPreferences.getBool('onBoard') == false) {
    if (CacheHelper.sharedPreferences.getString('uid') != null) {
      widgetToStart = '/home';
      print(CacheHelper.sharedPreferences.getString('uid'));
    } else {
      widgetToStart = '/login';
    }
  } else {
    widgetToStart = '/onBoarding';
  }
  Bloc.observer = MyBlocObserver();
  runApp(MyApp(
    widgetToStart: widgetToStart,
  ));
}

class MyApp extends StatelessWidget {
  final String widgetToStart;
  const MyApp({Key? key, required this.widgetToStart}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      initialRoute: widgetToStart,
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
