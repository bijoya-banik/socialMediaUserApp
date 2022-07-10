import 'package:flutter/cupertino.dart';
import 'package:buddyscripts/views/screens/account/components/ad_policy_rule_card.dart';

class AdPolicyTab extends StatelessWidget {
  const AdPolicyTab({Key? key}) : super(key: key);

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
              return const AdPolicyRuleCard();
            }),
          ),
        ),
      ],
    );
  }
}
