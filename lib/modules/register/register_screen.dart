import 'package:flutter/material.dart';
import 'package:social_app/shared/styles/styles.dart';

import 'package:social_app/shared/widgets/widgets.dart';

class RegisterScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
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
                SizedBox(
                  height: height * .01,
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
                    text: 'Register',
                    color: '#0065FF',
                    height: height * .06,
                    onTap: () {},
                    width: width * 0.9),
                SizedBox(
                  height: height * .02,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Joined Us Before?',
                      style: Theme.of(context).textTheme.caption!.copyWith(
                            fontSize: 18,
                          ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(
                        'Login',
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
