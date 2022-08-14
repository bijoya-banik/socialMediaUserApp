import 'package:buddyscripts/network/api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:buddyscripts/views/global_components/k_cupertino_nav_bar.dart';
import 'package:buddyscripts/views/styles/k_colors.dart';

class KImageView extends StatelessWidget {
  final String? url;

  const KImageView({Key? key, this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: KColor.blackConst,
      navigationBar: KCupertinoNavBar(
        backgroundColor: KColor.blackConst,
        arrowIconColor: KColor.whiteConst,
        automaticallyImplyLeading: false,
      ),
      child: InteractiveViewer(
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          alignment: Alignment.center,
          child: Image.network(
            API.baseUrl+url!,
            loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  value:
                      loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! : null,
                  strokeWidth: 2,
                  backgroundColor: KColor.grey.withOpacity(0.3),
                  valueColor: AlwaysStoppedAnimation<Color>(KColor.grey400!),
                ),
              );
            },
            errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [Icon(Icons.info), Text("Something went wrong")],
              );
            },
          ),
        ),
      ),
    );
  }
}
