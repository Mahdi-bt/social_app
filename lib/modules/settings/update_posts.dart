import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/states.dart';
import 'package:social_app/models/postModel.dart';
import 'package:social_app/shared/components.dart';
import 'package:social_app/shared/widgets/widgets.dart';

import '../../layout/cubit/cubit.dart';

class UpdatePostScreen extends StatefulWidget {
  const UpdatePostScreen({Key? key, required this.post, required this.postId})
      : super(key: key);
  final PostModel post;
  final String postId;

  @override
  State<UpdatePostScreen> createState() => _UpdatePostScreenState();
}

class _UpdatePostScreenState extends State<UpdatePostScreen> {
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    _textController.text = widget.post.postTitle;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Update Post',
          style: Theme.of(context).textTheme.headline6!.copyWith(
                color: Colors.black,
              ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * .05),
          child: BlocConsumer<HomeCubit, HomeLayoutStates>(
            listener: (context, state) {
              if (state is HomeGetPostSuccesState) {
                Navigator.pop(context);
              }
            },
            builder: (context, state) {
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
                    widget.post.mediaUrl != ""
                        ? SizedBox(
                            height: height * .34,
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                    14,
                                  ),
                                  child: cubit.postImage == null
                                      ? CachedNetworkImage(
                                          imageUrl: widget.post.mediaUrl,
                                          height: height * .3,
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
                                          cubit.postImage!,
                                          height: height * .3,
                                          fit: BoxFit.cover,
                                        ),
                                ),
                                Align(
                                  alignment: Alignment.topRight,
                                  child: InkWell(
                                    onTap: () {
                                      cubit.pickPostImage();
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
                              ],
                            ),
                          )
                        : const SizedBox(),
                    SizedBox(height: height * .01),
                    TextFormField(
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
                          borderSide: const BorderSide(
                              color: Colors.lightBlue, width: 2),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * .03,
                    ),
                    CustomButton(
                        center: state is HomeUpdatePostLoadingState
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(
                                'Update Post',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6!
                                    .copyWith(
                                      color: Colors.white,
                                    ),
                              ),
                        color: '#1885F2',
                        height: height * .065,
                        onTap: () async {
                          await cubit
                              .updatePost(
                                  postId: widget.postId,
                                  text: _textController.text)
                              .then((value) {
                            showToast(
                                text: 'Post Update Succsfully',
                                state: ToastStates.SUCCESS);
                          });
                        },
                        width: width)
                  ]);
            },
          ),
        ),
      ),
    );
  }
}
