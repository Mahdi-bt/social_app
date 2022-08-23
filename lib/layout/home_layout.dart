import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:social_app/layout/cubit/cubit.dart';
import 'package:social_app/layout/cubit/states.dart';
import 'package:social_app/shared/components.dart';
import 'package:social_app/shared/local/CacheHelper.dart';

class HomeLayout extends StatefulWidget {
  const HomeLayout({Key? key}) : super(key: key);

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  @override
  void dispose() {
    clearCache();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return BlocProvider(
        lazy: true,
        create: (context) => HomeCubit()
          ..getCurrentUser(uid: CacheHelper.sharedPreferences.getString('uid')!)
          ..getPosts(),
        child: BlocConsumer<HomeCubit, HomeLayoutStates>(
          listener: (context, state) {},
          builder: (context, state) {
            var cubit = HomeCubit.get(context);
            var currentIndex = cubit.currentIndex;
            return Scaffold(
              resizeToAvoidBottomInset: true,
              body: state is HomeGetPostLoadingState ||
                      state is HomeGetAllUsersLoadingState ||
                      state is HomeGetUserDataLoadingState ||
                      cubit.currentUser == null
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : cubit.screens[cubit.currentIndex],
              bottomNavigationBar: Container(
                margin: const EdgeInsets.all(20),
                height: screenWidth * .155,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.15),
                      blurRadius: 30,
                      offset: const Offset(0, 10),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(50),
                ),
                child: ListView.builder(
                  itemCount: 4,
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * .024),
                  itemBuilder: (context, index) => InkWell(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      cubit.changeBottomNavState(index);
                    },
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    child: Stack(
                      children: [
                        SizedBox(
                          width: screenWidth * .2125,
                          child: Center(
                            child: AnimatedContainer(
                              duration: const Duration(seconds: 1),
                              curve: Curves.fastLinearToSlowEaseIn,
                              height:
                                  index == currentIndex ? screenWidth * .12 : 0,
                              width: index == currentIndex
                                  ? screenWidth * .2125
                                  : 0,
                              decoration: BoxDecoration(
                                color: index == currentIndex
                                    ? Colors.blueAccent.withOpacity(.2)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: screenWidth * .2125,
                          alignment: Alignment.center,
                          child: Icon(
                            cubit.listOfIcons[index],
                            size: screenWidth * .076,
                            color: index == currentIndex
                                ? Colors.blueAccent
                                : Colors.black26,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ));
  }

  void clearCache() async {
    await DefaultCacheManager().emptyCache().then((value) {
      imageCache.clear();
      imageCache.clearLiveImages();
    });
  }
}
