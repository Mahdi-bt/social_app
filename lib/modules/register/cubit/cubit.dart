import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/models/userModel.dart';
import 'package:social_app/modules/register/cubit/states.dart';
import 'package:social_app/modules/register/register_screen.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit() : super(RegisterInitialStates());

  static RegisterCubit get(context) => BlocProvider.of(context);

  gender? userGender = gender.Female;

  void changeUserGender(gender? value) {
    userGender = value;
    emit(RegisterChangeUserGender());
  }

  userRegister(
      {required String userName, required String email, required String pass}) {
    emit(RegisterLoadingStates());
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: pass)
        .then((value) {
      userSaveData(userName: userName, email: email, uid: value.user!.uid);
    }).catchError((onError) {
      emit(RegisterFailedStaes());
    });
  }

  bool passVisbility = true;

  void changePasswordVisibility() {
    passVisbility = !passVisbility;
    emit(RegisterChangePassVisibility());
  }

  userSaveData(
      {required String userName, required String email, required String uid}) {
    UserModel _user = UserModel(
      coverPic:
          'https://firebasestorage.googleapis.com/v0/b/socialmedia-f51de.appspot.com/o/users_photos%2Fdefault_cover_pic.jpg?alt=media&token=7089482a-9a40-4593-bdeb-b2165a1a63ab',
      email: email,
      profilePic:
          'https://firebasestorage.googleapis.com/v0/b/socialmedia-f51de.appspot.com/o/users_photos%2Fdefault_profile_pic.jpeg?alt=media&token=0977f5d5-1cc2-42f1-8df2-e23a93ab52e1',
      uid: uid,
      userName: userName,
      gender: userGender!.name,
    );
    FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .set(_user.toMap())
        .then((value) {
      emit(RegisterSuccesStates());
    }).catchError((onError) {
      emit(RegisterFailedStaes());
    });
  }
}
