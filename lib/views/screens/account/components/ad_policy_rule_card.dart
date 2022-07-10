import 'package:flutter/material.dart';
import 'package:buddyscripts/views/styles/b_style.dart';

class AdPolicyRuleCard extends StatelessWidget {
   const AdPolicyRuleCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Rule No. 1', style: KTextStyle.subtitle1.copyWith(fontWeight: FontWeight.bold)),
          SizedBox(height: KSize.getHeight(context, 5)),
          Text(
            'Sellus aliquam portamor leocras itor aliquam roin. Himena tempor habitant eratetia uada felis. Necmae nec nisiinte non facilisi ivamus. Liberom unc cras lus tortorp mauris orciut vamus onec faucibus.',
            style: KTextStyle.bodyText2.copyWith(height: 1.25),
          ),
        ],
      ),
    );
  }
}
