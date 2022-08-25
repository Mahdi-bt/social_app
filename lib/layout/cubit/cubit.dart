import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:social_app/layout/cubit/states.dart';
import 'package:social_app/models/chatModel.dart';
import 'package:social_app/models/commentModel.dart';
import 'package:social_app/models/notificationModel.dart';
import 'package:social_app/models/postModel.dart';
import 'package:social_app/models/userModel.dart';
import 'package:social_app/modules/chat/contact_screen.dart';
import 'package:social_app/modules/feed/feed_screen.dart';
import 'package:social_app/modules/notifications/notification.dart';
import 'package:social_app/modules/settings/settings_screen.dart';
import 'package:social_app/shared/components.dart';
import 'package:social_app/shared/local/CacheHelper.dart';

import '../../modules/settings/update_user_info_screen.dart';

extension NotificationNa on NotificationType {
  String get name => describeEnum(this);
}

enum NotificationType { postLike, postComment, postReport }

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
    if (index == 3) {
      getMyPosts();
      getFollowersUser();
      getFollowingUser();
    }
    if (index == 1) {
      getUsers();
    }

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
      getFollowingUser();
      getFollowersUser();
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
  List<String> postsUid = [];
  Map<String, List<String>> postsLikes = {};
  Map<String, List<CommentModel>> postsComment = {};
  List<String> userLikesUid = [];
  List<CommentModel> usersComment = [];
  Future<void> getPosts() async {
    emit(HomeGetPostLoadingState());

    posts = [];
    postsUid = [];
    postsLikes = {};
    postsComment = {};
    FirebaseFirestore.instance
        .collection("posts")
        .orderBy('postTime')
        .get()
        .then((value) async {
      for (var element in value.docs) {
        if (element.data()['postLikes'] != 0) {
          await element.reference.collection("likes").get().then((value) {
            userLikesUid = [];
            for (var likesElment in value.docs) {
              userLikesUid.add(likesElment.id);
            }
            postsLikes[element.id] = userLikesUid;
            // print(postsLikes[element.id]);
          });
        } else {
          postsLikes[element.id] = [];
        }

        if (element.data()['postComment'] != 0) {
          await element.reference.collection("comment").get().then((value) {
            usersComment = [];
            for (var commentElment in value.docs) {
              usersComment.add(CommentModel.formJson(commentElment.data()));
            }
            postsComment[element.id] = usersComment;
            // print(postsLikes[element.id]);
          });
        } else {
          postsComment[element.id] = [];
        }

        postsUid.add(element.id);
        posts.add(PostModel.fromJson(element.data()));
      }
      // postsLikes.forEach((key, value) {
      //   print("$key,$value");
      // });

      emit(HomeGetPostSuccesState());
    }).catchError((onError) {
      emit(HomeGetPostFailedSate());
    });
  }

  likePost({required String postId}) async {
    emit(HomeLikePostLoadingState());
    String reciver = "";
    await FirebaseFirestore.instance
        .collection("posts")
        .doc(postId)
        .collection("likes")
        .doc(currentUser!.uid)
        .set({"like": true}).then((value) {
      FirebaseFirestore.instance
          .collection("posts")
          .doc(postId)
          .get()
          .then((value) {
        PostModel model = PostModel.fromJson(value.data()!);
        model.postLikes++;
        reciver = model.posterUid;
        FirebaseFirestore.instance
            .collection("posts")
            .doc(postId)
            .set(model.toMap());
      }).then((value) {
        postsLikes[postId]!.add(currentUser!.uid);
        if (reciver == currentUser!.uid) {
          emit(HomeLikePostSuccesState());
        } else {
          sendNotification(
              reciverUserUid: reciver,
              senderUserUid: currentUser!.uid,
              notificationType: NotificationType.postLike,
              postUid: postId,
              userName: currentUser!.userName);
          emit(HomeLikePostSuccesState());
        }
      });
    }).catchError((onError) {
      emit(HomeGetAllUsersFailedState());
    });
  }

  removeLike({required String postUid}) {
    emit(HomeDeleteLikePostLoadingState());
    FirebaseFirestore.instance
        .collection("posts")
        .doc(postUid)
        .collection("likes")
        .doc(currentUser!.uid)
        .delete()
        .then((value) {
      FirebaseFirestore.instance
          .collection("posts")
          .doc(postUid)
          .get()
          .then((value) {
        PostModel model = PostModel.fromJson(value.data()!);
        model.postLikes--;
        FirebaseFirestore.instance
            .collection("posts")
            .doc(postUid)
            .set(model.toMap());
      }).then((value) {
        postsLikes[postUid]!.remove(currentUser!.uid);

        emit(HomeDeleteLikePostSuccesState());
      });
    }).catchError((onError) {
      emit(HomeDeleteLikePostFailedState());
    });
  }

  List<UserModel> commentUsers = [];
  Future<void> getUsersCommentList({required String Uid}) async {
    emit(HomeGetPostCommentLoadingState());

    for (var element in postsComment[Uid]!) {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(element.commentUserUid)
          .get()
          .then((value) {
        commentUsers.add(UserModel.fromJson(value.data()!));
      });
    }
    emit(HomeGetPostCommentSuccesState());
  }

  commentPost({required String postUid, required String commentText}) async {
    emit(HomeCommentPostLoadingState());
    String reciver = "";
    CommentModel comment = CommentModel(
        commentText: commentText,
        commentUserPic: currentUser!.profilePic,
        commentUserUid: currentUser!.uid,
        date: DateFormat('kk:mm EEE d MMM').format(DateTime.now()));
    await FirebaseFirestore.instance
        .collection("posts")
        .doc(postUid)
        .collection("comment")
        .doc(currentUser!.uid)
        .set(comment.toMap())
        .then((value) {
      FirebaseFirestore.instance
          .collection("posts")
          .doc(postUid)
          .get()
          .then((value) {
        PostModel model = PostModel.fromJson(value.data()!);
        model.postComment++;
        reciver = model.posterUid;
        FirebaseFirestore.instance
            .collection("posts")
            .doc(postUid)
            .set(model.toMap());
      }).then((value) {
        postsComment[postUid]!.add(comment);

        if (reciver == currentUser!.uid) {
        } else {
          sendNotification(
            reciverUserUid: reciver,
            senderUserUid: currentUser!.uid,
            notificationType: NotificationType.postComment,
            postUid: postUid,
            userName: currentUser!.userName,
          );
        }
        getUsersCommentList(Uid: postUid);
        emit(HomeCommentPostSuccesState());
      }).catchError((onError) {
        emit(HomeCommentPostFailedState());
      });
    }).catchError((onError) {
      emit(HomeCommentPostFailedState());
    });
  }

  void sendMessage({
    required String reciverId,
    required String messageText,
  }) {
    emit(HomeSendMessageLoadingState());

    if (messageImage != null) {
      FirebaseStorage.instance
          .ref("message_images/${messageImage!.path.split('/').last}")
          .putFile(messageImage!)
          .then((p0) {
        p0.ref.getDownloadURL().then((value) {
          ChatModel chat = ChatModel(
            messageText: messageText,
            imageUrl: value,
            reciverId: reciverId,
            senderId: currentUser!.uid,
            dateTime: DateFormat('kk:mm EEE ').format(
              DateTime.now(),
            ),
          );
          FirebaseFirestore.instance
              .collection("users")
              .doc(currentUser!.uid)
              .collection("chats")
              .doc(reciverId)
              .collection("messages")
              .add(chat.toMap())
              .then((value) {
            FirebaseFirestore.instance
                .collection("users")
                .doc(reciverId)
                .collection("chats")
                .doc(currentUser!.uid)
                .collection("messages")
                .add(chat.toMap())
                .then((value) {
                  deleteMessageImage();
                  emit(HomeSendMessageSuccesState());
                })
                .catchError((onError) {})
                .catchError((onError) {
                  emit(HomeSendMessageFailedState());
                });
          }).catchError((onError) {
            emit(HomeSendMessageFailedState());
          });
        });
      }).catchError((onError) {});
    } else {
      ChatModel chat = ChatModel(
        messageText: messageText,
        reciverId: reciverId,
        senderId: currentUser!.uid,
        dateTime: DateFormat('kk:mm EEE ').format(
          DateTime.now(),
        ),
        imageUrl: '',
      );
      FirebaseFirestore.instance
          .collection("users")
          .doc(currentUser!.uid)
          .collection("chats")
          .doc(reciverId)
          .collection("messages")
          .add(chat.toMap())
          .then((value) {
        FirebaseFirestore.instance
            .collection("users")
            .doc(reciverId)
            .collection("chats")
            .doc(currentUser!.uid)
            .collection("messages")
            .add(chat.toMap())
            .then((value) {
              emit(HomeSendMessageSuccesState());
            })
            .catchError((onError) {})
            .catchError((onError) {
              emit(HomeSendMessageFailedState());
            });
      }).catchError((onError) {
        emit(HomeSendMessageFailedState());
      });
    }
  }

  List<ChatModel> chats = [];
  void getMessages({required String reciverId}) {
    FirebaseFirestore.instance
        .collection("users")
        .doc(currentUser!.uid)
        .collection("chats")
        .doc(reciverId)
        .collection("messages")
        .orderBy('dateTime', descending: true)
        .snapshots()
        .listen((event) {
      chats = [];
      for (var element in event.docs) {
        chats.add(ChatModel.fromJson(element.data()));
      }
      emit(HomeGetMessageSuccesState());
    });
  }

  File? messageImage;

  pickMessageImage() async {
    var pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      messageImage = File(pickedFile.path);
      debugPrint(pickedFile.path);
      emit(HomePickMessageImageSuccesState());
    } else {
      debugPrint('No image selected.');
      emit(HomePickMessageImageFailedState());
    }
  }

  deleteMessageImage() async {
    messageImage = null;
    emit(HomePickMessageImageDeleteState());
  }

  List<PostModel> myPosts = [];
  List<String> myPostUid = [];
  Future<void> getMyPosts() async {
    emit(HomeGetMyPostLoadingState());
    myPosts = [];
    myPostUid = [];
    await FirebaseFirestore.instance
        .collection("posts")
        .where("posterUid", isEqualTo: currentUser!.uid)
        .get()
        .then((value) {
      for (var elment in value.docs) {
        myPosts.add(PostModel.fromJson(elment.data()));
        myPostUid.add(elment.id);
      }
    }).then((value) {
      emit(HomeGetMyPostSuccesState());
    }).catchError((onError) {
      emit(HomeGetMyPostFailedState());
    });
  }

  Future<void> deletePost({required String postUid, required int index}) async {
    emit(HomeDeletePostLoadingState());
    await FirebaseFirestore.instance
        .collection("posts")
        .doc(postUid)
        .delete()
        .then((value) {
      myPosts.removeAt(index);
      posts.removeAt(index);
      postsLikes.removeWhere((key, value) => key == postUid);
      postsComment.removeWhere((key, value) => key == postUid);

      getMyPosts();
      getPosts();
      emit(HomeDeletePostSuccesState());
    }).catchError((onError) {
      HomeDeletePostFailedState();
    });
  }

  Future<void> updatePost({
    required String postId,
    required String text,
  }) async {
    emit(HomeUpdatePostLoadingState());
    if (postImage != null) {
      await FirebaseStorage.instance
          .ref("posts_images/${postImage!.path.split('/').last}")
          .putFile(postImage!)
          .then((p0) {
        p0.ref.getDownloadURL().then((value) {
          FirebaseFirestore.instance.collection("posts").doc(postId).update({
            "postTitle": text,
            "mediaUrl": value,
          }).then((value) async {
            deletePostImage();
            await getPosts();
            await getMyPosts();
            emit(HomeUpdatePostSuccesState());
          }).catchError((onError) {
            emit(HomeUpdatePostFailedState());
          });
        });
      }).catchError((onError) {
        emit(HomeUpdatePostFailedState());
      });
    } else {
      await FirebaseFirestore.instance.collection("posts").doc(postId).update({
        "postTitle": text,
      }).then((value) {
        emit(HomeUpdatePostSuccesState());
      }).catchError((onError) {
        emit(HomeUpdatePostFailedState());
      });
    }
  }

  gender? userGender = gender.Female;

  void changeUserGender(gender? value) {
    userGender = value;
    emit(HomeChangeUserGender());
  }

  File? newProfileImage;

  pickProfileImage() async {
    var pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      newProfileImage = File(pickedFile.path);
      debugPrint(pickedFile.path);
      emit(HomePickImageSuccesState());
    } else {
      debugPrint('No image selected.');
      emit(HomePickImageFailedState());
    }
  }

  File? newCoverImage;

  pickNewCoverImage() async {
    var pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      newCoverImage = File(pickedFile.path);
      debugPrint(pickedFile.path);
      emit(HomePickImageSuccesState());
    } else {
      debugPrint('No image selected.');
      emit(HomePickImageFailedState());
    }
  }

  deleteNewProfileImage() async {
    newProfileImage = null;
    emit(HomePickMessageImageDeleteState());
  }

  deleteNewCoverImage() async {
    newProfileImage = null;
    emit(HomePickMessageImageDeleteState());
  }

  Future<void> updateUserCredential(
      {required String username,
      required String phoneNumber,
      required String gender}) async {
    emit(HomeUpdateUserCredentialLoadingState());
    UserModel newUserModel = currentUser!;
    newUserModel.userName = username;
    newUserModel.phoneNumber = phoneNumber;
    newUserModel.gender = gender;
    if (newProfileImage != null) {
      await FirebaseStorage.instance
          .ref("users_photo/${newProfileImage!.path.split('/').last}")
          .putFile(newProfileImage!)
          .then((p0) {
        p0.ref.getDownloadURL().then((value) {
          newUserModel.profilePic = value;

          FirebaseFirestore.instance
              .collection("users")
              .doc(currentUser!.uid)
              .set(newUserModel.toMap())
              .then((value) {
            deleteNewProfileImage();
          }).catchError((onError) {
            emit(HomeUpdateUserCredentialFailedState());
          });
        });
      });
    }
    if (newCoverImage != null) {
      await FirebaseStorage.instance
          .ref("users_photo/${newCoverImage!.path.split('/').last}")
          .putFile(newCoverImage!)
          .then((p0) {
        p0.ref.getDownloadURL().then((value) {
          newUserModel.coverPic = value;
          FirebaseFirestore.instance
              .collection("users")
              .doc(currentUser!.uid)
              .set(newUserModel.toMap())
              .then((value) {
            deleteNewProfileImage();
          }).catchError((onError) {
            emit(HomeUpdateUserCredentialFailedState());
          });
        });
      });
    }
    FirebaseFirestore.instance
        .collection("users")
        .doc(currentUser!.uid)
        .set(newUserModel.toMap())
        .then((value) {
      deleteNewProfileImage();
      emit(HomeUpdateUserCredentialSuccesState());
    }).catchError((onError) {
      emit(HomeUpdateUserCredentialFailedState());
    });
  }

  Future<void> sendNotification({
    required String reciverUserUid,
    required String senderUserUid,
    required NotificationType notificationType,
    required String userName,
    required String postUid,
  }) async {
    emit(HomeSendNotificationLoadingState());
    NotificationModel notificationModel = NotificationModel(
        date: DateFormat('kk:mm EEE d MMM').format(DateTime.now()),
        reciverUid: reciverUserUid,
        senderUid: senderUserUid,
        type: notificationType.name,
        postUid: postUid,
        userName: userName);
    switch (notificationType) {
      case NotificationType.postLike:
        FirebaseFirestore.instance
            .collection("users")
            .doc(reciverUserUid)
            .collection("notification")
            .add(notificationModel.toMap())
            .then((value) {
          emit(HomeSendNotificationSuccesState());
        }).catchError((onError) {
          emit(HomeSendNotificationFailedState());
        });
        break;
      case NotificationType.postComment:
        FirebaseFirestore.instance
            .collection("users")
            .doc(reciverUserUid)
            .collection("notification")
            .add(notificationModel.toMap())
            .then((value) {
          emit(HomeSendNotificationSuccesState());
        }).catchError((onError) {
          emit(HomeSendNotificationFailedState());
        });
        break;

      case NotificationType.postReport:
        FirebaseFirestore.instance
            .collection("users")
            .doc(reciverUserUid)
            .collection("notification")
            .add(notificationModel.toMap())
            .then((value) {
          emit(HomeSendNotificationSuccesState());
        }).catchError((onError) {
          emit(HomeSendNotificationFailedState());
        });
        break;
    }
  }

  List<NotificationModel> notification = [];
  void getNotification() {
    FirebaseFirestore.instance
        .collection("users")
        .doc(currentUser!.uid)
        .collection("notification")
        .orderBy('date')
        .snapshots()
        .listen((event) {
      notification = [];
      for (var element in event.docs) {
        notification.add(NotificationModel.fromJson(element.data()));
      }
      emit(HomeGetUserNotificationState());
    });
  }

  deleteUserNotification() {
    emit(HomeDeleteUserNotificationLoadingState());
    FirebaseFirestore.instance
        .collection("users")
        .doc(currentUser!.uid)
        .collection("notification")
        .get()
        .then((value) {
      for (var element in value.docs) {
        element.reference.delete();
      }
      notification = [];
      emit(HomeDeleteUserNotificationSuccesState());
    }).catchError((onError) {
      emit(HomeDeleteUserNotificationFailedState());
    });
  }

  List<String> followingUsers = [];
  List<String> followersUsers = [];

  Future<void> followPerson({required String userId}) async {
    emit(HomeFollowPersonLoadingState());
    FirebaseFirestore.instance
        .collection("users")
        .doc(currentUser!.uid)
        .collection("following")
        .doc(userId)
        .set({"follwing": true}).then((value) {
      FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .collection("followers")
          .doc(currentUser!.uid)
          .set({
        "follow": true,
      }).then((value) {
        followingUsers.add(userId);
        emit(HomeFollowPersonSuccesState());
      }).catchError((onError) {
        emit(HomeFollowPersonFailedState());
      });
    }).catchError((onError) {
      emit(HomeFollowPersonFailedState());
    });
  }

  Future<void> getFollowingUser() async {
    emit(HomeGetFollowingUsersLoadingState());
    followingUsers = [];
    FirebaseFirestore.instance
        .collection("users")
        .doc(currentUser!.uid)
        .collection('following')
        .get()
        .then((value) {
      for (var element in value.docs) {
        followingUsers.add(element.id);
      }
      emit(HomeGetFollowingUsersSuccesState());
    }).catchError((onError) {
      emit(HomeGetFollowingUsersFailedState());
    });
  }

  Future<void> getFollowersUser() async {
    emit(HomeGetFollowersUsersLoadingState());
    followersUsers = [];
    FirebaseFirestore.instance
        .collection("users")
        .doc(currentUser!.uid)
        .collection('followers')
        .get()
        .then((value) {
      if (value.docs.isEmpty) {
      } else {
        for (var element in value.docs) {
          followersUsers.add(element.id);
        }
      }

      emit(HomeGetFollowersUsersSuccesState());
    }).catchError((onError) {
      emit(HomeGetFollowersUsersFailedState());
    });
  }

  Future<void> unfllowUser({required String userId}) async {
    emit(HomeUnfollowUserLoadingState());
    FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("followers")
        .doc(currentUser!.uid)
        .get()
        .then((value) {
      value.reference.delete();
      FirebaseFirestore.instance
          .collection("users")
          .doc(currentUser!.uid)
          .collection("following")
          .doc(userId)
          .get()
          .then((value) {
        value.reference.delete();
        followingUsers.remove(userId);
        emit(HomeUnfollowUserSuccesState());
      }).catchError((onError) {
        emit(HomeUnfollowUserFailedState());
      });
    }).catchError((onError) {
      emit(HomeUnfollowUserFailedState());
    });
  }
}
