import 'package:buddyscripts/controller/page/page_about_controller.dart';
import 'package:buddyscripts/controller/page/state/page_about_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:buddyscripts/views/global_components/k_cupertino_nav_bar.dart';
import 'package:buddyscripts/views/styles/b_style.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class PageAboutScreen extends ConsumerWidget {
  const PageAboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageAboutState = ref.watch(pageAboutProvider);
    final pageAboutData = pageAboutState is PageAboutSuccessState ? pageAboutState.pageAboutModel.basicOverView : null;

    return CupertinoPageScaffold(
      backgroundColor: KColor.white,
      navigationBar: pageAboutState is PageAboutSuccessState
          ? KCupertinoNavBar(title: pageAboutState.pageAboutModel.basicOverView!.pageName, automaticallyImplyLeading: false, hasLeading: true)
          : null,
      child: pageAboutState is PageAboutSuccessState
          ? CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                CupertinoSliverRefreshControl(onRefresh: () {
                  return Future.value();
                }),
                SliverToBoxAdapter(
                    child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('About', style: KTextStyle.headline5.copyWith(fontWeight: FontWeight.bold, color: KColor.black)),
                          SizedBox(height: KSize.getHeight(context, 15)),
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            minLeadingWidth: 5,
                            dense: true,
                            leading: Icon(Icons.info_outlined, color: KColor.black87),
                            title: Text(
                              pageAboutData?.about ?? '',
                              style: KTextStyle.bodyText3.copyWith(color: KColor.black87, height: KSize.getHeight(context, 1.5)),
                            ),
                          ),
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            minLeadingWidth: 5,
                            dense: true,
                            leading: Icon(Icons.rss_feed, color: KColor.black87),
                            title: Text('${pageAboutData?.totalPageLikes} people follow this',
                                style: KTextStyle.subtitle1.copyWith(color: KColor.black87)),
                          ),
                          pageAboutData?.website == null || pageAboutData?.website == ""
                              ? Container()
                              : ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  minLeadingWidth: 5,
                                  dense: true,
                                  leading:
                                      pageAboutData?.website == null || pageAboutData?.website == "" ? null : Icon(Icons.web, color: KColor.black87),
                                  title: InkWell(
                                    onTap: () {
                                      if (pageAboutData?.website != null || pageAboutData?.website != "") launch(pageAboutData?.website);
                                    },
                                    child: Text(
                                      pageAboutData?.website ?? "",
                                      style: KTextStyle.bodyText3.copyWith(color: KColor.blue, height: KSize.getHeight(context, 1.5)),
                                    ),
                                  ),
                                ),
                          pageAboutData?.categoryName == null || pageAboutData?.categoryName == ""
                              ? Container()
                              : ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  minLeadingWidth: 5,
                                  dense: true,
                                  leading: pageAboutData?.categoryName == null || pageAboutData?.categoryName == ""
                                      ? null
                                      : Icon(Icons.subject, color: KColor.black87),
                                  title: Text(
                                    pageAboutData?.categoryName ?? "",
                                    style: KTextStyle.bodyText3.copyWith(color: KColor.black87, height: KSize.getHeight(context, 1.5)),
                                  ),
                                ),
                          pageAboutData?.phone == null || pageAboutData?.phone == ""
                              ? Container()
                              : ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  minLeadingWidth: 5,
                                  dense: true,
                                  leading:
                                      pageAboutData?.phone == null || pageAboutData?.phone == "" ? null : Icon(Icons.phone, color: KColor.black87),
                                  title: Text(
                                    pageAboutData?.phone ?? "",
                                    style: KTextStyle.bodyText3.copyWith(color: KColor.black87, height: KSize.getHeight(context, 1.5)),
                                  ),
                                ),
                          pageAboutData?.email == null || pageAboutData?.email == ""
                              ? Container()
                              : ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  minLeadingWidth: 5,
                                  dense: true,
                                  leading:
                                      pageAboutData?.email == null || pageAboutData?.email == "" ? null : Icon(Icons.email, color: KColor.black87),
                                  title: Text(
                                    pageAboutData?.email ?? "",
                                    style: KTextStyle.bodyText3.copyWith(color: KColor.black87, height: KSize.getHeight(context, 1.5)),
                                  ),
                                ),
                          pageAboutData?.address == "" && pageAboutData?.city == "" && pageAboutData?.country == ""
                              ? Container()
                              : ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  minLeadingWidth: 5,
                                  dense: true,
                                  leading: (pageAboutData?.address == "" && pageAboutData?.city == "" && pageAboutData?.country == "")
                                      ? null
                                      : Icon(Icons.location_on, color: KColor.black87),
                                  title: Text(
                                    pageAboutData?.address == "" && pageAboutData?.city == "" && pageAboutData?.country == ""
                                        ? ""
                                        : pageAboutData?.address == null
                                            ? ""
                                            : '${pageAboutData!.address}' +
                                                (pageAboutData.city == "" || pageAboutData.city == null ? "" : ', ${pageAboutData.city}') +
                                                (pageAboutData.country == "" || pageAboutData.country == null ? "" : ', ${pageAboutData.country}'),
                                    style: KTextStyle.bodyText3.copyWith(color: KColor.black87, height: KSize.getHeight(context, 1.5)),
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ],
                )),
              ],
            )
          : const Center(child: CupertinoActivityIndicator()),
    );
  }
}
