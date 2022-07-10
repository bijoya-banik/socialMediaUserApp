import 'package:buddyscripts/controller/feed/poll_option_voters_controller.dart';
import 'package:buddyscripts/controller/feed/state/poll_option_voters_state.dart';
import 'package:buddyscripts/controller/pagination/poll/poll_option_voters_scroll_provider.dart';
import 'package:buddyscripts/controller/pagination/scroll_state.dart';
import 'package:buddyscripts/services/app_mode.dart';
import 'package:buddyscripts/views/global_components/loading_indicators/k_loading_indicator.dart';
import 'package:buddyscripts/views/global_components/user_name.dart';
import 'package:buddyscripts/views/global_components/user_profile_picture.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:buddyscripts/views/styles/b_style.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PollOptionVotersScreen extends StatefulWidget {
  final int? pollId, optionId;
  const PollOptionVotersScreen({Key? key, this.pollId, this.optionId}) : super(key: key);

  @override
  _PollOptionVotersScreenState createState() => _PollOptionVotersScreenState();
}

class _PollOptionVotersScreenState extends State<PollOptionVotersScreen> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final pollOptionVotersState = ref.watch(pollOptionVotersProvider);
        final pollOptionVoters = pollOptionVotersState is PollOptionVotersSuccessState ? pollOptionVotersState.pollOptionVoters : [];

        final pollOptionVotersScrollState = ref.watch(pollOptionVotersScrollProvider);

        ref.listen(pollOptionVotersScrollProvider, (_, state) {
          if (state is ScrollReachedBottomState) {
            ref.read(pollOptionVotersProvider.notifier).fetchMorePollOptionVoters(widget.pollId, widget.optionId);
          }
        });

        return Scaffold(
            backgroundColor: AppMode.darkMode ? KColor.appBackground : KColor.white,
            appBar: AppBar(
              backgroundColor: KColor.secondary,
              elevation: 1,
              titleSpacing: 0,
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios, size: 18, color: KColor.black),
                onPressed: () => Navigator.pop(context),
              ),
              title: Text('Voters for this option', style: KTextStyle.subtitle1.copyWith(fontWeight: FontWeight.w500, color: KColor.black)),
            ),
            body: pollOptionVotersState is PollOptionVotersSuccessState
                ? Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          controller: ref.read(pollOptionVotersScrollProvider.notifier).controller,
                          itemCount: pollOptionVoters.length,
                          itemBuilder: (BuildContext context, i) {
                            return Container(
                              margin: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 2),
                              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  UserProfilePicture(
                                      profileURL: pollOptionVoters[i].user.profilePic,
                                      avatarRadius: 22,
                                      slug: pollOptionVoters[i].user.username,
                                      onTapNavigate: true,
                                      iconSize: 21.5),
                                  UserName(
                                    name: "${pollOptionVoters[i].user.firstName} ${pollOptionVoters[i].user.lastName}",
                                    slug: pollOptionVoters[i].user.username,
                                    onTapNavigate: true,
                                    backgroundColor: AppMode.darkMode ? KColor.appBackground : KColor.whiteConst,
                                    textStyle: KTextStyle.bodyText1.copyWith(color: KColor.black87, fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      if (pollOptionVotersScrollState is ScrollReachedBottomState && pollOptionVoters.isNotEmpty)
                        Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.only(bottom: 10),
                          child: const CupertinoActivityIndicator(),
                        )
                    ],
                  )
                : const Center(child: KLoadingIndicator()));
      },
    );
  }
}
