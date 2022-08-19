import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/cubit.dart';
import 'package:social_app/layout/cubit/states.dart';
import 'package:social_app/shared/components.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

class NewPostScreen extends StatelessWidget {
  NewPostScreen({Key? key}) : super(key: key);
  var formKey = GlobalKey<FormState>();
  final _textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return BlocListener<HomeCubit, HomeLayoutStates>(
      listener: (context, state) {
        if (state is HomeUploadPostSuccesStates) {
          showToast(text: 'Post Added Succfuly', state: ToastStates.SUCCESS);
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Create New Post',
            style: Theme.of(context).textTheme.headline6,
          ),
          centerTitle: true,
          actions: [
            BlocBuilder<HomeCubit, HomeLayoutStates>(
              builder: (context, state) {
                if (state is HomeUploadPostLoadingStates) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.blue,
                      strokeWidth: 3,
                    ),
                  );
                } else {
                  return TextButton(
                    onPressed: () => HomeCubit.get(context).postImage != null
                        ? HomeCubit.get(context)
                            .createPostWithPic(text: _textController.text)
                        : HomeCubit.get(context)
                            .createPost(text: _textController.text),
                    child: Text('Post',
                        style: Theme.of(context).textTheme.subtitle1!.copyWith(
                              color: Colors.lightBlue,
                            )),
                  );
                }
              },
            )
          ],
        ),
        body: SingleChildScrollView(
            child: Column(
          children: [
            Container(
              height: height * .001,
              width: double.infinity,
              color: Colors.grey[300],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  BlocBuilder<HomeCubit, HomeLayoutStates>(
                    builder: (context, state) => CircleAvatar(
                      radius: 20,
                      backgroundImage: CachedNetworkImageProvider(
                        HomeCubit.get(context).currentUser!.profilePic,
                      ),
                    ),
                  ),
                  SizedBox(width: width * .04),
                  BlocBuilder<HomeCubit, HomeLayoutStates>(
                    builder: (context, state) => Text(
                      HomeCubit.get(context).currentUser!.userName,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: formKey,
                child: TextFormField(
                  controller: _textController,
                  validator: (value) {},
                  minLines: 10,
                  maxLines: 12,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    hintText: 'Have Somthenig to share with the community?',
                    hintStyle: const TextStyle(color: Colors.grey),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide:
                          const BorderSide(color: Colors.grey, width: 2),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide:
                          const BorderSide(color: Colors.grey, width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      gapPadding: 0.0,
                      borderRadius: BorderRadius.circular(15),
                      borderSide:
                          const BorderSide(color: Colors.lightBlue, width: 2),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () async {
                      await context.read<HomeCubit>().pickPostImage();
                    },
                    icon: const Icon(Icons.add_a_photo_rounded),
                    label: const Text('Add Media'),
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.redAccent,
                    ),
                    onPressed: () {},
                    icon: const Icon(IconBroken.Document),
                    label: const Text('Add Document'),
                  ),
                ],
              ),
            ),
            BlocBuilder<HomeCubit, HomeLayoutStates>(
              builder: (context, state) {
                if (HomeCubit.get(context).postImage != null) {
                  return Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.file(
                          context.read<HomeCubit>().postImage!,
                          fit: BoxFit.cover,
                          height: height * 0.3,
                          width: width * 0.9,
                        ),
                      ),
                      Positioned(
                        right: 8,
                        child: InkWell(
                          onTap: () =>
                              context.read<HomeCubit>().deletePostImage(),
                          child: Container(
                            height: height * 0.1,
                            width: width * 0.1,
                            decoration: BoxDecoration(
                                color: Colors.grey[300],
                                shape: BoxShape.circle),
                            child: const Icon(
                              Icons.cancel,
                              color: Colors.redAccent,
                              size: 30,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),
          ],
        )),
      ),
    );
  }
}
