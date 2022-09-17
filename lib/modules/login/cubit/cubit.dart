import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:social_app/models/userModel.dart';
import 'package:social_app/modules/login/cubit/states.dart';
import 'package:social_app/shared/constant.dart';
import 'package:social_app/shared/local/CacheHelper.dart';

import '../../../shared/components.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginInitialState());

  static LoginCubit get(context) => BlocProvider.of(context);

  bool passVisbility = true;

  void changePasswordVisibility() {
    passVisbility = !passVisbility;
    emit(LoginChangePassVisibility());
  }

  userLoginWithEmailAndPass({required String email, required String pass}) {
    emit(LoginLoadingState());
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: pass)
        .then((value) {
      CacheHelper.sharedPreferences
          .setString('uid', value.user!.uid)
          .then((newvalue) {
        FirebaseFirestore.instance
            .collection("users")
            .doc(value.user!.uid)
            .update({"fcmToken": fcmToken}).then((value) {
          emit(LoginSuccesState());
        }).catchError((onError) {
          emit(LoginFailedState());
        });
      }).catchError((onError) {
        emit(LoginFailedState());
      });
    }).catchError((onError) {
      emit(LoginFailedState());
    });
  }

  Future googleLogin() async {
    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) {
      return;
    }
    emit(LoginWithGoogleLoadingState());
    user = googleUser;
    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    await FirebaseAuth.instance.signInWithCredential(credential).then((value) {
      UserModel userModel = UserModel(
        coverPic:
            'https://firebasestorage.googleapis.com/v0/b/socialmedia-f51de.appspot.com/o/users_photos%2Fdefault_cover_pic.jpg?alt=media&token=7089482a-9a40-4593-bdeb-b2165a1a63ab',
        email: value.user!.email!,
        profilePic: value.user!.photoURL!,
        uid: value.user!.uid,
        userName: value.user!.displayName!,
        gender: 'Male',
        fcmToken: fcmToken,
      );
      FirebaseFirestore.instance
          .collection("users")
          .doc(value.user!.uid)
          .set(userModel.toMap())
          .then((newvalue) {
        CacheHelper.sharedPreferences
            .setString('uid', value.user!.uid)
            .then((value) {
          emit(LoginWithGoogleSuccesSates());
        }).catchError((onError) {
          emit(LoginWithGoogleFailedState());
        });
      }).catchError((onError) {
        emit(LoginWithGoogleFailedState());
      });
    }).catchError((onError) {
      emit(LoginWithGoogleFailedState());
    });
  }
}
