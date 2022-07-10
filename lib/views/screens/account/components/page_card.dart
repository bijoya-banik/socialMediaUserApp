import 'package:buddyscripts/constants/asset_path.dart';
import 'package:buddyscripts/controller/page/page_controller.dart';
import 'package:buddyscripts/controller/page/page_feed_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:buddyscripts/views/global_components/k_button.dart';
import 'package:buddyscripts/views/screens/account/pages/page_details_screen.dart';
import 'package:buddyscripts/views/styles/b_style.dart';

class PageCard extends ConsumerStatefulWidget {
  final String type;
  final dynamic pageData;
  const PageCard(this.type, this.pageData, {Key? key}) : super(key: key);

  @override
  _PageCardState createState() => _PageCardState();
}

class _PageCardState extends ConsumerState<PageCard> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return  Column(
            children: [
              InkWell(
                onTap: () {
                  ref.read(pageFeedProvider.notifier).fetchPageFeed(widget.pageData.slug);
                  Navigator.push(context, CupertinoPageRoute(builder: (context) => PageDetailsScreen()));
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 10),
                      child: CircleAvatar(
                          radius: widget.type == 'Discover' ? 40 : 25,
                          backgroundColor: KColor.grey100,
                          backgroundImage: const AssetImage(AssetPath.profilePlaceholder),
                          foregroundImage: NetworkImage(widget.pageData.profilePic)),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: KSize.getHeight(context, 10)),
                          Text(widget.pageData.pageName, style: KTextStyle.subtitle1.copyWith(color: KColor.black87, fontWeight: FontWeight.w600)),
                          SizedBox(height: KSize.getHeight(context, 3)),
                          if (widget.type != 'Followed')
                            Text(
                                widget.pageData.totalPageLikes > 1
                                    ? '${widget.pageData.totalPageLikes} Followers'
                                    : '${widget.pageData.totalPageLikes} Follower',
                                overflow: TextOverflow.ellipsis,
                                style: KTextStyle.bodyText3.copyWith(color: KColor.black54)),
                          if (widget.type == 'Followed')
                            Text(widget.pageData.about, overflow: TextOverflow.ellipsis, style: KTextStyle.bodyText3.copyWith(color: KColor.black54)),
                          SizedBox(height: KSize.getHeight(context, 7)),
                          if (widget.type == 'Discover')
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.70,
                              child: KButton(
                                title: isLoading ? 'Please wait...' : 'Follow',
                                color: isLoading ? KColor.grey : KColor.buttonBackground,
                                leadingTitleIcon: const Icon(Icons.rss_feed, size: 20, color: KColor.whiteConst),
                                innerPadding: 8.5,
                                onPressedCallback: isLoading
                                    ? null
                                    : () async {
                                        if (!mounted) return;
                                        setState(() {
                                          isLoading = true;
                                        });
                                        await ref.read(pageProvider.notifier).followPage(
                                              widget.pageData.id,
                                            );
                                        if (!mounted) return;
                                        setState(() {
                                          isLoading = false;
                                        });
                                      },
                              ),
                            ),
                        ],
                      ),
                    ),
                    if (widget.type == 'Followed')
                      Container(
                        decoration: BoxDecoration(
                          color: isLoading ? KColor.grey350 : KColor.transparent,
                          borderRadius: const BorderRadius.all(Radius.circular(6)),
                        ),
                        margin: const EdgeInsets.only(left: 20),
                        width: MediaQuery.of(context).size.width * 0.25,
                        child: KButton(
                          isOutlineButton: true,
                          title: isLoading ? 'Please wait...' : 'Unfollow',
                          innerPadding: 7.5,
                          onPressedCallback: isLoading
                              ? null
                              : () async {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  await ref.read(pageProvider.notifier).unfollowPage(
                                        widget.pageData.id,
                                      );
                                  setState(() {
                                    isLoading = false;
                                  });
                                },
                        ),
                      )
                  ],
                ),
              ),
              SizedBox(height: KSize.getHeight(context, 12)),
            ],
          );
  }
}
