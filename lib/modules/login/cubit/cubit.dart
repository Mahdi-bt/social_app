import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:social_app/modules/login/cubit/states.dart';
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
          .then((value) {
        emit(LoginSuccesState());
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
      emit(LoginWithGoogleSuccesSates());
    }).catchError((onError) {
      emit(LoginWithGoogleFailedState());
    });
  }
}
