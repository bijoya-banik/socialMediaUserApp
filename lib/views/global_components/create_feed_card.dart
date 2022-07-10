import 'package:buddyscripts/controller/auth/state/user_state.dart';
import 'package:buddyscripts/controller/auth/user_controller.dart';
import 'package:buddyscripts/controller/feed/feed_controller.dart';
import 'package:buddyscripts/services/app_mode.dart';
import 'package:flutter/cupertino.dart';
import 'package:buddyscripts/views/global_components/k_text_field.dart';
import 'package:buddyscripts/views/global_components/user_profile_picture.dart';
import 'package:buddyscripts/views/screens/home/create_feed_screen.dart';
import 'package:buddyscripts/views/styles/b_style.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateFeedCard extends StatelessWidget {
  final FeedType feedType;
  final int? id;

  const CreateFeedCard({this.feedType = FeedType.PROFILE, this.id, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      decoration:
          BoxDecoration(color: AppMode.darkMode ? KColor.appBackground : KColor.white, borderRadius: const BorderRadius.all(Radius.circular(6))),
      child: Row(
        children: [
          Consumer(
            builder: (context, ref, _) {
              final userState = ref.watch(userProvider);
              final userData = userState is UserSuccessState ? userState.userModel.user : null;
              return UserProfilePicture(
                avatarRadius: 20,
                profileURL: userData?.profilePic,
                onTapNavigate: false,
                type: 'profile',
              );
            },
          ),
          Expanded(
            child: SizedBox(
              height: 55,
              child: KTextField(
                backgroundColor: AppMode.darkMode ? KColor.grey850! : KColor.appBackground,
                hintText: 'Create a new post',
                hintColor: KColor.black87,
                topMargin: 0,
                borderRadius: 15,
                isReadOnly: true,
                contentPaddingVerticle: 16,
                onTap: () {
                  Navigator.of(context, rootNavigator: true).push(
                    CupertinoPageRoute(fullscreenDialog: true, builder: (context) => CreateFeedScreen(feedType: feedType, id: id ?? 0)),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
