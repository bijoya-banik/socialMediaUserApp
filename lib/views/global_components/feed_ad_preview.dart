import 'package:buddyscripts/models/feed/feed_model.dart';
import 'package:buddyscripts/views/global_components/k_button.dart';
import 'package:buddyscripts/views/styles/b_style.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class FeedAdPreview extends StatelessWidget {
  final Campaign campaignData;
  const FeedAdPreview(this.campaignData, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async => await launch(campaignData.destinationUrl!),
      child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 7),
          margin: const EdgeInsets.only(top: 10),
          decoration: BoxDecoration(color: KColor.grey100, border: Border.all(color: KColor.grey350!, width: 1)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (campaignData.title!.isNotEmpty)
                      Container(
                        margin: const EdgeInsets.only(bottom: 6),
                        child: Text(campaignData.title ?? '', style: KTextStyle.subtitle1.copyWith(color: KColor.black)),
                      ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 6),
                      child: Text(
                        campaignData.shortDescription ?? '',
                        maxLines: null,
                        style: KTextStyle.bodyText2.copyWith(color: KColor.black54),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 6),
                            child: Text(
                              campaignData.destinationUrl == null ? "" : Uri.parse(campaignData.destinationUrl!).host.toString(),
                              style: KTextStyle.bodyText2.copyWith(color: KColor.black54),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.25,
                          child: KButton(
                            isOutlineButton: true,
                            title: campaignData.text ?? '',
                            innerPadding: 5,
                            textOverflow: TextOverflow.ellipsis,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
