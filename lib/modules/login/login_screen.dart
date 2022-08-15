import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:social_app/shared/styles/styles.dart';
import 'package:social_app/shared/widgets/customButton.dart';

import 'package:social_app/shared/widgets/widgets.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/login_image.jpg',
                  height: height * .3,
                ),
                Text(
                  "Login to your account now",
                  style: Theme.of(context).textTheme.headline5!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: HexColor('#192D4E'),
                        fontSize: 26,
                      ),
                ),
                SizedBox(
                  height: height * .02,
                ),
                CustomTextFormField(
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
                  myController: _passwordController,
                  prefixIcon: Icons.lock,
                  suffixIcon: Icons.remove_red_eye,
                  hintText: 'Password',
                  labelText: 'Enter your Password',
                ),
                Align(
                  alignment: AlignmentDirectional.topEnd,
                  child: TextButton(
                    onPressed: () =>
                        Navigator.of(context).pushNamed('/forgetPassword'),
                    child: Text(
                      'Forget Password',
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            color: Colors.blue,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                ),
                CustomButton(
                    center: const Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    color: '#0065FF',
                    height: height * .06,
                    onTap: () {},
                    width: width * 0.9),
                SizedBox(
                  height: height * .02,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width / 2 - 60,
                      color: Colors.grey[300],
                      height: 2,
                    ),
                    Text(
                      'OR',
                      style: Theme.of(context).textTheme.caption!.copyWith(
                            fontSize: 18,
                          ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 2 - 40,
                      color: Colors.grey[300],
                      height: 2,
                    ),
                  ],
                ),
                SizedBox(
                  height: height * .02,
                ),
                Container(
                  height: 45,
                  width: 320,
                  decoration: BoxDecoration(
                    color: HexColor('F1F5F6'),
                    borderRadius: BorderRadius.circular(
                      16,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SvgPicture.asset(
                        'assets/images/google.svg',
                        height: 22,
                      ),
                      Text(
                        'Login With Google',
                        style: Theme.of(context).textTheme.headline5!.copyWith(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: height * .02,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'New to the logistics?',
                      style: Theme.of(context).textTheme.caption!.copyWith(
                            fontSize: 18,
                          ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed('/register');
                      },
                      child: Text(
                        'Register',
                        style: Theme.of(context).textTheme.headline6!.copyWith(
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
        ));
  }
}
