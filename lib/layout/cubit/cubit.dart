import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:social_app/layout/cubit/states.dart';
import 'package:social_app/models/postModel.dart';
import 'package:social_app/models/userModel.dart';
import 'package:social_app/modules/chat/contact_screen.dart';
import 'package:social_app/modules/feed/feed_screen.dart';
import 'package:social_app/modules/notifications/notification.dart';
import 'package:social_app/modules/settings/settings_screen.dart';
import 'package:social_app/shared/components.dart';
import 'package:social_app/shared/local/CacheHelper.dart';

class HomeCubit extends Cubit<HomeLayoutStates> {
  HomeCubit() : super(HomeInitialState());
  static HomeCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  List<IconData> listOfIcons = [
    Icons.home_rounded,
    Icons.person_rounded,
    Icons.notifications,
    Icons.settings_rounded,
  ];
  List<Widget> screens = [
    const FeedScreen(),
    const ContactScrenn(),
    NotificationScreen(),
    const SettingsScreen()
  ];
  void changeBottomNavState(int index) {
    currentIndex = index;
    emit(HomeChangeBottomNavState());
  }

  logOut(context) async {
    await FirebaseAuth.instance.signOut().then((value) {
      CacheHelper.sharedPreferences.remove('uid').then((value) {
        emit(HomeLogOutSuccesStates());
        Navigator.of(context).pushReplacementNamed('/login');
      }).catchError((onError) {
        emit(HomeLogOutFailedSates());
      });
    });
  }

  logOutFromGoogle(context) async {
    await googleSignIn.disconnect();
    await FirebaseAuth.instance.signOut().then((value) {
      CacheHelper.sharedPreferences.remove('uid').then((value) {
        emit(HomeLogOutSuccesStates());
        Navigator.of(context).pushReplacementNamed('/login');
      }).catchError((onError) {
        emit(HomeLogOutFailedSates());
      });
    });
  }

  UserModel? currentUser;
  getCurrentUser({required String uid}) async {
    emit(HomeGetUserDataLoadingState());
    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .get()
        .then((value) {
      currentUser = UserModel.fromJson(value.data()!);
      emit(HomeGetUserDataSuccesState());
      print(value.data());
    }).catchError((onError) {
      emit(HomeGetUserDataFailedState());
    });
  }

  File? postImage;

  var picker = ImagePicker();

  pickPostImage() async {
    var pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      postImage = File(pickedFile.path);
      debugPrint(pickedFile.path);
      emit(HomePickImageSuccesState());
    } else {
      debugPrint('No image selected.');
      emit(HomePickImageFailedState());
    }
  }

  deletePostImage() async {
    postImage = null;
    emit(HomePostImageDeleteSuccfuly());
  }

  createPostWithPic({required String text}) async {
    emit(HomeUploadPostLoadingStates());
    FirebaseStorage.instance
        .ref("posts_images/${postImage!.path.split('/').last}")
        .putFile(postImage!)
        .then((p0) {
      p0.ref.getDownloadURL().then((value) {
        createPost(text: text, imageUrl: value);
      });
    }).catchError((onError) {});
  }

  createPost({required String text, String imageUrl = ""}) async {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('kk:mm EEE d MMM').format(now);
    PostModel postModel = PostModel(
        mediaUrl: imageUrl,
        postTime: formattedDate,
        postTitle: text,
        posterName: currentUser!.userName,
        posterUid: currentUser!.uid,
        posterPhotoUrl: currentUser!.profilePic);
    FirebaseFirestore.instance
        .collection("posts")
        .add(postModel.toMap())
        .then((value) {
      deletePostImage();
      getPosts();
      emit(HomeUploadPostSuccesStates());
    }).catchError((onError) {
      emit(HomeUploadPostFailedStates());
    });
  }

  List<UserModel> users = [];
  getUsers() async {
    emit(HomeGetAllUsersLoadingState());
    users = [];
    FirebaseFirestore.instance.collection("users").get().then((value) {
      for (var element in value.docs) {
        var userModel = UserModel.fromJson(element.data());
        if (userModel.uid != currentUser!.uid) {
          users.add(userModel);
        }
      }
      emit(HomeGetAllUsersSuccesState());
    }).catchError((onError) {
      emit(HomeGetAllUsersFailedState());
    });
  }

  List<PostModel> posts = [];
  List<int> postsLikes = [];
  getPosts() async {
    posts = [];
    emit(HomeGetPostLoadingState());
    FirebaseFirestore.instance.collection("posts").get().then((value) {
      for (var element in value.docs) {
        posts.add(PostModel.fromJson(element.data()));
      }
      FirebaseFirestore.instance.collection("posts").doc()
      emit(HomeGetPostSuccesState());
    }).then((value) {
      emit(HomeGetPostFailedSate());
    });
  }

  likePost({required String postId}) async {
    emit(HomeLikePostLoadingState());
    await FirebaseFirestore.instance
        .collection("posts")
        .doc(postId)
        .collection("likes")
        .add({
      "uid": currentUser!.uid,
      "name": currentUser!.userName,
    }).then((value) {
      emit(HomeLikePostSuccesState());
    }).catchError((onError) {
      emit(HomeGetAllUsersFailedState());
    });
  }
}
