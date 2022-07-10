import 'package:buddyscripts/controller/feed/report_feed_controller.dart';
import 'package:buddyscripts/services/navigation_service.dart';
import 'package:buddyscripts/views/global_components/dialogs/k_dialog.dart';
import 'package:buddyscripts/views/global_components/dialogs/processing_dialog_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:buddyscripts/services/validator.dart';
import 'package:buddyscripts/views/global_components/k_button.dart';
import 'package:buddyscripts/views/global_components/k_cupertino_nav_bar.dart';
import 'package:buddyscripts/views/global_components/k_text_field.dart';
import 'package:buddyscripts/views/styles/b_style.dart';

class ReportFeedScreen extends ConsumerWidget {
  final dynamic feedData;
  final dynamic reportType;
  const ReportFeedScreen(this.feedData, this.reportType, {Key? key}) : super(key: key);

//   @override
//   _ReportFeedScreenState createState() => _ReportFeedScreenState();
// }

// class _ReportFeedScreenState extends State<ReportFeedScreen> {

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TextEditingController reportMessageController = TextEditingController();

    final _formKey = GlobalKey<FormState>();
    return CupertinoPageScaffold(
      backgroundColor: KColor.darkAppBackground,
      navigationBar: KCupertinoNavBar(title: 'Report Post', automaticallyImplyLeading: false, hasLeading: true),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: KSize.getWidth(context, 15)),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                KTextField(
                  contentPaddingVerticle: 20,
                  hintText: "Type in your reason",
                  maxLines: 5,
                  autofocus: true,
                  controller: reportMessageController,
                  validator: (v) => Validators.fieldValidator(v),
                ),
                SizedBox(height: KSize.getHeight(context, 20)),
                KButton(
                  title: 'Report',
                  onPressedCallback: () async {
                    if (_formKey.currentState!.validate()) {
                      KDialog.kShowDialog(
                        context,
                        const ProcessingDialogContent("Processing..."),
                        barrierDismissible: false,
                      );
                      FocusScope.of(context).unfocus();
                      await ref
                          .read(reportFeedProvider.notifier)
                          .reportFeed(feed: feedData, reportType: reportType, reportText: reportMessageController.text);
                      NavigationService.popNavigate();
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
