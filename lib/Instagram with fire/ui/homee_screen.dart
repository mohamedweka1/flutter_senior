import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:flutter_senior/Instagram%20with%20fire/buisness_logic/posts/posts_cubit.dart';
import 'package:flutter_senior/Instagram%20with%20fire/data/models/post.dart';
import 'package:flutter_senior/Instagram%20with%20fire/ui/comment_screen.dart';
import 'package:flutter_senior/Instagram%20with%20fire/ui/post_screen.dart';
import 'package:flutter_senior/Instagram%20with%20fire/ui/story_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class HomeeScreen extends StatelessWidget {
  late BuildContext context;
  late PostsCubit cubit;

  @override
  Widget build(BuildContext context) {
    this.context = context;
    cubit = BlocProvider.of<PostsCubit>(context);
    cubit.getPosts();

    return BlocListener<PostsCubit, PostsStates>(
      listener: (context, state) {
        print("Home state => $state");
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: screenAppBar(),
        body: screenBody(),
      ),
    );
  }

  AppBar screenAppBar() => AppBar(
    backgroundColor: Colors.black,
    title: const Text(
      "Instagram",
      style: TextStyle(color: Colors.white),
    ),
    actions: [
      IconButton(
          onPressed: () {
            onAddBoxTapped(context);
          },
          icon: const Icon(Icons.add_box_outlined)),
      IconButton(onPressed: () {}, icon: const Icon(Icons.favorite_border)),
      IconButton(onPressed: () {}, icon: const Icon(Icons.chat_outlined)),
    ],
  );

  Widget screenBody() => ListView(
    children: [
      buildStories(),
      const Divider(
        color: Colors.white,
        height: 0.1,
        thickness: 0.1,
      ),
      postsListView(),
    ],
  );

  Widget postsListView() {
    return BlocBuilder<PostsCubit, PostsStates>(
      buildWhen: (previous, current) {
        return current is PostsGetSuccessStates ||
              current is LikePostSuccessStates ||
              current is UnLikePostSuccessStates;
      },
      builder: (context, state) {
        return ListView.separated(
          shrinkWrap: true,
          physics: const ScrollPhysics(),
          itemBuilder: (context, index) => buildPostItem(cubit.posts[index], index),
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemCount: cubit.posts.length,
        );
      },
    );
  }

  buildStories() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        children: [
          SizedBox(
            height: 110,
            child: InkWell(
              onTap: () => onAddStoryTapped(),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: const [
                      CircleAvatar(
                        backgroundImage: NetworkImage(
                            "https://wirepicker.com/wp-content/uploads/2021/09/android-vs-ios_1200x675.jpg"),
                        radius: 35,
                      ),
                      CircleAvatar(
                        backgroundColor: Colors.black,
                        radius: 13,
                      ),
                      CircleAvatar(
                        backgroundColor: Colors.blue,
                        child: Icon(Icons.add),
                        radius: 11,
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Text(
                    "Your story",
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: SizedBox(
              height: 110,
              child: ListView.separated(
                separatorBuilder: (context, index) => const SizedBox(
                  width: 10,
                ),
                itemBuilder: (context, index) => buildStoryItem(),
                itemCount: 20,
                scrollDirection: Axis.horizontal,
              ),
            ),
          )
        ],
      ),
    );
  }

  buildStoryItem() {
    return InkWell(
      onTap: () => onShowStoryTapped(),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              CircleAvatar(
                radius: 36,
                child: Container(
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(colors: [
                        Color(0xff833ab4),
                        Color(0xfffd1d1d),
                        Color(0xfffcb045),
                      ])),
                ),
              ),
              const CircleAvatar(
                backgroundImage: NetworkImage(
                    "https://wirepicker.com/wp-content/uploads/2021/09/android-vs-ios_1200x675.jpg"),
                radius: 33,
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          const Text(
            "Amir",
            style: TextStyle(color: Colors.white),
          )
        ],
      ),
    );
  }

  buildPostItem(Post post, int index) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  CircleAvatar(
                    radius: 26,
                    child: Container(
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(colors: [
                            Color(0xff833ab4),
                            Color(0xfffd1d1d),
                            Color(0xfffcb045),
                          ])),
                    ),
                  ),
                  CircleAvatar(
                    backgroundImage: NetworkImage(post.userImageUrl),
                    radius: 23,
                  ),
                ],
              ),
              const SizedBox(
                width: 5,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.username,
                      // "Amir Mohammed",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      post.locationName,
                      // "Meeru island resort & spa",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
              IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.more_horiz,
                    color: Colors.white,
                  ))
            ],
          ),
        ),
        Image(
            height: 30.h,
            width: double.infinity,
            fit: BoxFit.cover,
            image: NetworkImage(
              post.postImageUrl,
              // "https://wirepicker.com/wp-content/uploads/2021/09/android-vs-ios_1200x675.jpg",
            )),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              IconButton(
                  onPressed: () {
                    if (cubit.posts[index].isLiked) {
                      cubit.posts[index].likesCount--;
                      cubit.posts[index].isLiked = false;
                      cubit.UnlikePost(post.postId);
                    } else {
                      cubit.posts[index].likesCount++;
                      cubit.posts[index].isLiked = true;
                      cubit.likePost(post.postId);
                    }
                  },
                  icon:  Icon(
                    post.isLiked ? Icons.favorite : Icons.favorite_border,
                    color: Colors.white,
                  )),
              IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>  CommentsScreen(postId:post.postId),
                        ));
                  },
                  icon: const Icon(
                    Icons.mode_comment_outlined,
                    color: Colors.white,
                  )),
              IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.send_outlined,
                    color: Colors.white,
                  )),
              const Spacer(),
              IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.bookmark_border,
                    color: Colors.white,
                  )),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 23.0),
          child: Text(
            "${post.likesCount}",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(
          height: 4,
        ),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 23.0),
            child: RichText(
                text: TextSpan(children: [
                  TextSpan(
                      text: post.username,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  const TextSpan(text: " "),
                  TextSpan(text: post.postContent)
                ]))),
      ],
    );
  }

  onAddStoryTapped() async {
    final ImagePicker _picker = ImagePicker();

    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    print(image!.path);

    // File file = File(image!.path);
  }

  onShowStoryTapped() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => StoryScreen(),
    ));
  }

  void onAddBoxTapped(context) {
    showMenu<String>(
      color: const Color(0xE6000000),
      context: context,
      position: const RelativeRect.fromLTRB(100, 80, 99.8, 100),
      //position where you want to show the menu on screen
      shape: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        // borderSide: BorderSide(
        //   color: Theme.of(context).focusColor,
        //   width: 2,
        //   style: BorderStyle.solid,
        // ),
      ),
      items: [
        PopupMenuItem<String>(
          value: '1',
          child: Row(
            children: [
              Text(
                'Post',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              const Spacer(),
              const SizedBox(
                width: 8,
              ),
              Icon(MaterialIcons.post_add, color: Theme.of(context).focusColor),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: '2',
          child: Expanded(
            child: Row(
              children: [
                Text(
                  'Story',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                const Spacer(),
                Icon(MaterialCommunityIcons.plus_circle_outline,
                    color: Theme.of(context).focusColor),
              ],
            ),
          ),
        ),
        PopupMenuItem<String>(
          value: '3',
          child: Expanded(
            child: Row(
              children: [
                Text(
                  'Reel',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                const Spacer(),
                Icon(MaterialIcons.live_tv,
                    color: Theme.of(context).focusColor),
              ],
            ),
          ),
        ),
        PopupMenuItem<String>(
          value: '4',
          child: Expanded(
            child: Row(
              children: [
                Text(
                  'Live',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                const Spacer(),
                Icon(Fontisto.livestream, color: Theme.of(context).focusColor),
              ],
            ),
          ),
        ),
      ],
      elevation: 8.0,
    ).then<void>((String? itemSelected) {
      if (itemSelected == null) return;

      if (itemSelected == "1") {
        pickImage();
      } else if (itemSelected == "2") {
        //code here
      } else {
        //code here
      }
    });
  }

  void pickImage() async {
    final ImagePicker _picker = ImagePicker();
    // Pick an image
    _picker.pickImage(source: ImageSource.gallery).then((value) {
      File file = File(value!.path);

      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PostScreen(
              imageFile: file,
            ),
          )).then((value) => cubit.getPosts());
    });
  }
}