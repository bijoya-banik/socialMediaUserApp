import 'package:flutter/cupertino.dart';
import 'package:buddyscripts/views/screens/account/components/campaigns_card.dart';

class CampaignsTab extends StatelessWidget {
  const CampaignsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // CupertinoSliverRefreshControl(
        //   onRefresh: () {
        //     return ;
        //   },
        // ),
        SliverToBoxAdapter(
          child: Column(
            children: List.generate(10, (index) {
              return const CampaignsCard();
            }),
          ),
        ),
      ],
    );
  }
}
