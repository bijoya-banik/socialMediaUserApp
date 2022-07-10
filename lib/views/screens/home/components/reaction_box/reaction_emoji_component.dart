import 'package:buddyscripts/constants/asset_path.dart';
import 'package:flutter/material.dart';

class ReactionEmojiComponent extends StatelessWidget {
  final String? reactionType;
  final double height;

  const ReactionEmojiComponent({Key? key, this.reactionType, this.height = 20.0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      reactionType == 'WOW'
          ? AssetPath.wowReaction
          : reactionType == 'LOVE'
              ? AssetPath.loveReaction
              : reactionType == 'HAHA'
                  ? AssetPath.hahaReaction
                  : reactionType == 'SAD'
                      ? AssetPath.sadReaction
                      : reactionType == 'ANGRY'
                          ? AssetPath.angryReaction
                          : AssetPath.likeReaction,
      height: height,
    );
  }
}
