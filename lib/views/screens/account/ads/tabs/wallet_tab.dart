import 'package:flutter/cupertino.dart';
import 'package:buddyscripts/views/screens/account/components/wallet_balance_card.dart';
import 'package:buddyscripts/views/screens/account/components/wallet_transactions_card.dart';

class WalletTab extends StatelessWidget {
  const WalletTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // CupertinoSliverRefreshControl(
        //   onRefresh: () {
        //     return;
        //   },
        // ),
        const SliverToBoxAdapter(child: WalletBalanceCard(title: 'Current Balance', value: '100')),
        SliverToBoxAdapter(
          child: Column(
            children: List.generate(10, (index) {
              return const WalletTransactionsCard();
            }),
          ),
        ),
      ],
    );
  }
}
