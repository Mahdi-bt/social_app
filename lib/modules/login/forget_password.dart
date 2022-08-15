import 'package:flutter/material.dart';
import 'package:social_app/shared/styles/styles.dart';
import 'package:social_app/shared/widgets/widgets.dart';

class ForgetPasswordScreen extends StatelessWidget {
  ForgetPasswordScreen({Key? key}) : super(key: key);
  TextEditingController _emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/forget_password.jpg',
                height: height * .3,
              ),
              Text(
                'Forget Password?',
                style: Theme.of(context)
                    .textTheme
                    .headline3!
                    .copyWith(color: HexColor('#1F3353')),
              ),
              SizedBox(
                height: height * .01,
              ),
              Text(
                'don\'t worry it happens. please enter the adress associated with your account',
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(color: HexColor('#344563')),
              ),
              SizedBox(
                height: height * .03,
              ),
              CustomTextFormField(
                prefixIcon: Icons.email_rounded,
                suffixIcon: null,
                hintText: 'Email ID / Phone Number',
                labelText: 'Enter Your ID',
                myController: _emailController,
              ),
              SizedBox(
                height: height * .03,
              ),
              CustomButton(
                  text: 'Submit',
                  color: '#0065FF',
                  height: height * .06,
                  onTap: () {},
                  width: width * 0.9),
            ],
          ),
        ),
      ),
    );
  }
}
