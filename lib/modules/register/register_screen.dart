import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/modules/register/cubit/cubit.dart';
import 'package:social_app/modules/register/cubit/states.dart';
import 'package:social_app/shared/components.dart';
import 'package:social_app/shared/styles/styles.dart';

import 'package:social_app/shared/widgets/widgets.dart';

extension GenderEx on gender {
  String get name => describeEnum(this);
}

enum gender { Male, Female }

class RegisterScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return BlocProvider(
      create: (context) => RegisterCubit(),
      child: BlocConsumer<RegisterCubit, RegisterStates>(
        listener: (context, state) {
          if (state is RegisterSuccesStates) {
            showToast(
                text: "Account Create Succesfuly", state: ToastStates.SUCCESS);
            Navigator.pop(context);
          }
          if (state is RegisterFailedStaes) {
            showToast(
                text: "Failed To Create Account", state: ToastStates.ERROR);
          }
        },
        builder: (context, state) {
          var cubit = RegisterCubit.get(context);
          return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 12.0,
                    right: 12.0,
                  ),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/register.jpg',
                          height: height * .3,
                          fit: BoxFit.cover,
                        ),
                        Text(
                          "Create Your Account Now",
                          style:
                              Theme.of(context).textTheme.headline5!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: HexColor('#192D4E'),
                                    fontSize: 26,
                                  ),
                        ),
                        SizedBox(
                          height: height * .02,
                        ),
                        CustomTextFormField(
                          validator: (value) {
                            if (value!.isEmpty || value.length < 6) {
                              return "Enter A Valid Username";
                            }
                            return null;
                          },
                          myController: _nameController,
                          prefixIcon: Icons.face_outlined,
                          suffixIcon: null,
                          hintText: 'Full Name',
                          labelText: 'Enter your Name',
                        ),
                        SizedBox(
                          height: height * .02,
                        ),
                        CustomTextFormField(
                          validator: (value) {
                            Pattern pattern =
                                r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                                r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                                r"{0,253}[a-zA-Z0-9])?)*$";
                            RegExp regex = RegExp(pattern.toString());
                            if (!regex.hasMatch(value!)) {
                              return 'Enter a valid email address';
                            } else {
                              return null;
                            }
                          },
                          myController: _emailController,
                          prefixIcon: Icons.email,
                          suffixIcon: null,
                          hintText: 'Email ID',
                          labelText: 'Enter your email Adress',
                        ),
                        SizedBox(
                          height: height * .02,
                        ),
                        CustomTextFormField(
                          validator: (value) {
                            RegExp regex = RegExp(
                                r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
                            if (value!.isEmpty) {
                              return 'Please enter password';
                            } else {
                              if (!regex.hasMatch(value.toString())) {
                                return 'Enter valid password';
                              } else {
                                return null;
                              }
                            }
                          },
                          myController: _passwordController,
                          obsecureText: cubit.passVisbility,
                          suffixPressed: () => cubit.changePasswordVisibility(),
                          prefixIcon: Icons.lock,
                          suffixIcon: Icons.remove_red_eye,
                          hintText: 'Password',
                          labelText: 'Enter your Password',
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              "Gender:",
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                            Expanded(
                              child: ListTile(
                                title: const Text('Female'),
                                leading: Radio<gender>(
                                  value: gender.Female,
                                  groupValue: cubit.userGender,
                                  onChanged: (gender? value) =>
                                      cubit.changeUserGender(value),
                                ),
                              ),
                            ),
                            Expanded(
                              child: ListTile(
                                title: const Text('Male'),
                                leading: Radio<gender>(
                                  value: gender.Male,
                                  groupValue: cubit.userGender,
                                  onChanged: (gender? value) =>
                                      cubit.changeUserGender(value),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: height * .001,
                        ),
                        Text(
                          'By signing up, you\'re agree to our ',
                          style: TextStyle(
                            color: HexColor(
                              '#5E6C84',
                            ),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: const Size(50, 30),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              alignment: Alignment.centerLeft),
                          child: const Text(
                            'Terms & Condition and Privacy Policy',
                          ),
                        ),
                        SizedBox(
                          height: height * .01,
                        ),
                        CustomButton(
                            center: state is RegisterLoadingStates
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 3,
                                  )
                                : const Text(
                                    'Register',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                            color: '#0065FF',
                            height: height * .06,
                            onTap: () async {
                              if (formKey.currentState!.validate()) {
                                cubit.userRegister(
                                    userName: _nameController.text,
                                    email: _emailController.text,
                                    pass: _passwordController.text);
                              }
                            },
                            width: width * 0.9),
                        SizedBox(
                          height: height * .001,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Joined Us Before?',
                              style:
                                  Theme.of(context).textTheme.caption!.copyWith(
                                        fontSize: 18,
                                      ),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text(
                                'Login',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6!
                                    .copyWith(
                                        color: Colors.blue,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ));
        },
      ),
    );
  }
}
