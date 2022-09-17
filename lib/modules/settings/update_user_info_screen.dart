import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/models/userModel.dart';
import 'package:social_app/shared/components.dart';
import 'package:social_app/shared/widgets/widgets.dart';

import '../../layout/cubit/cubit.dart';
import '../../layout/cubit/states.dart';

extension GenderEx on gender {
  String get name => describeEnum(this);
}

enum gender { Male, Female }

class UpdateUserCredential extends StatefulWidget {
  UpdateUserCredential({Key? key, required this.userModel}) : super(key: key);
  final UserModel userModel;

  @override
  State<UpdateUserCredential> createState() => _UpdateUserCredentialState();
}

class _UpdateUserCredentialState extends State<UpdateUserCredential> {
  final TextEditingController _usernameController = TextEditingController();

  final TextEditingController _phoneController = TextEditingController();

  final TextEditingController _oldPasswordController = TextEditingController();

  final TextEditingController _newPasswordController = TextEditingController();
  @override
  void initState() {
    _usernameController.text = widget.userModel.userName;
    _phoneController.text = widget.userModel.phoneNumber;
    HomeCubit.get(context).userGender =
        widget.userModel.gender == "Male" ? gender.Male : gender.Female;
    super.initState();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'User Credential',
            style: Theme.of(context).textTheme.headline6!.copyWith(
                  color: Colors.black,
                ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                await HomeCubit.get(context).updateUserCredential(
                    username: _usernameController.text,
                    phoneNumber: _phoneController.text,
                    gender: HomeCubit.get(context).userGender!.name);
              },
              child: Text(
                'Update Settings',
                style: Theme.of(context)
                    .textTheme
                    .subtitle1!
                    .copyWith(color: Colors.blue),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: width * .05),
                child: BlocConsumer<HomeCubit, HomeLayoutStates>(
                    listener: (context, state) {
                  if (state is HomeUpdateUserCredentialSuccesState) {
                    showToast(
                        text: 'Credential Update Succesfully',
                        state: ToastStates.SUCCESS);
                    Navigator.pop(context);
                  }
                  if (state is HomeUpdateUserCredentialFailedState) {
                    showToast(
                        text: 'Cant Update Credential',
                        state: ToastStates.ERROR);
                  }
                }, builder: (context, state) {
                  var cubit = HomeCubit.get(context);
                  return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 1.0,
                          color: Colors.grey.shade100,
                        ),
                        SizedBox(
                          height: height * .01,
                        ),
                        SizedBox(
                          height: height * .34,
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(
                                  14,
                                ),
                                child: cubit.newCoverImage == null
                                    ? CachedNetworkImage(
                                        imageUrl: cubit.currentUser!.coverPic,
                                        height: height * .3,
                                        width: width,
                                        maxHeightDiskCache: 200,
                                        fit: BoxFit.cover,
                                        key: UniqueKey(),
                                        placeholder: (context, url) =>
                                            Container(
                                          color: Colors.black12,
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Container(
                                          color: Colors.black12,
                                          child: const Icon(Icons.report),
                                        ),
                                      )
                                    : Image.file(
                                        cubit.newCoverImage!,
                                        height: height * .3,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                              Align(
                                alignment: Alignment.topRight,
                                child: InkWell(
                                  onTap: () {
                                    cubit.pickNewCoverImage();
                                  },
                                  child: Container(
                                    height: height * .054,
                                    width: width * .1,
                                    decoration: const BoxDecoration(
                                        color: Colors.blue,
                                        shape: BoxShape.circle),
                                    child: const Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                left: width * .5 - 53,
                                child: CircleAvatar(
                                  radius: 48,
                                  backgroundColor: Colors.grey,
                                  child: CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      backgroundImage: cubit.newProfileImage ==
                                              null
                                          ? CachedNetworkImageProvider(
                                              cubit.currentUser!.profilePic)
                                          : Image.file(cubit.newProfileImage!)
                                              .image,
                                      radius: 45),
                                ),
                              ),
                              Positioned(
                                bottom: height * .0,
                                left: width * .55,
                                child: InkWell(
                                  onTap: () {
                                    cubit.pickProfileImage();
                                  },
                                  child: Container(
                                    height: height * .045,
                                    width: width * .1,
                                    decoration: const BoxDecoration(
                                        color: Colors.blue,
                                        shape: BoxShape.circle),
                                    child: const Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: height * .05),
                        CustomTextFormField(
                            prefixIcon: Icons.face,
                            suffixIcon: null,
                            hintText: 'Enter your Username',
                            labelText: 'Username',
                            myController: _usernameController),
                        SizedBox(height: height * .02),
                        CustomTextFormField(
                            prefixIcon: Icons.phone,
                            suffixIcon: null,
                            hintText: 'Enter your Phone Number',
                            labelText: 'Phone Number',
                            myController: _phoneController),
                        SizedBox(height: height * .02),
                        CustomTextFormField(
                            prefixIcon: Icons.lock,
                            suffixIcon: null,
                            hintText: 'Enter previous Password',
                            labelText: 'Old Password',
                            myController: _oldPasswordController),
                        SizedBox(height: height * .02),
                        CustomTextFormField(
                            prefixIcon: Icons.lock,
                            suffixIcon: null,
                            hintText: 'Enter New Password',
                            labelText: 'Password',
                            myController: _newPasswordController),
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
                      ]);
                }))));
  }
}
