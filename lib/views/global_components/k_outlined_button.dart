import 'package:buddyscripts/services/app_mode.dart';
import 'package:buddyscripts/views/styles/k_colors.dart';
import 'package:flutter/material.dart';

class KOutlinedButton extends StatelessWidget {
  final String? buttonText;
  final String? feedBackText;
  final bool? isSelect;
  final VoidCallback? onTap;

  const KOutlinedButton({
    Key? key,
    this.buttonText,
    this.feedBackText,
    this.isSelect,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
        child: Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(10),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelect! ? KColor.primary : KColor.white,
              border: Border.all(color: isSelect! ? KColor.white : KColor.primary, width: 1.0),
              borderRadius: const BorderRadius.all(Radius.circular(5.0)),
            ),
            child: Text(
              buttonText ?? '',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: isSelect! ? Colors.white : KColor.primary),
            ),
          ),
        ),
        feedBackText != ""
            ? Container(
                margin: const EdgeInsets.only(top: 2, bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Icon(Icons.info_outline, size: 15, color: KColor.primary),
                    const SizedBox(width: 3),
                    Text(
                      feedBackText ?? '',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppMode.darkMode ? KColor.whiteConst : KColor.black87, fontSize: 12),
                    ),
                  ],
                ),
              )
            : const SizedBox(height: 20)
      ],
    ));
  }
}
