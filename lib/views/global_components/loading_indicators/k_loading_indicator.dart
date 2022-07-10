import 'package:flutter/material.dart';
import 'package:buddyscripts/views/styles/k_colors.dart';

class KLoadingIndicator extends StatelessWidget {
  final Color backgroundColor, valueColor;
  final double strokeWidth;

   const KLoadingIndicator({Key? key, this.backgroundColor = KColor.greyconst, this.valueColor = KColor.greyconst, this.strokeWidth = 2.0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      width: 30,
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth,
        backgroundColor: backgroundColor.withOpacity(0.3),
        valueColor: AlwaysStoppedAnimation<Color>(valueColor.withOpacity(0.4)),
      ),
    );
  }
}
