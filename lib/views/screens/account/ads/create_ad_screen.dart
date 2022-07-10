import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:buddyscripts/services/date_time_service.dart';
import 'package:buddyscripts/views/global_components/k_button.dart';
import 'package:buddyscripts/views/global_components/k_cupertino_nav_bar.dart';
import 'package:buddyscripts/views/global_components/k_text_field.dart';
import 'package:buddyscripts/views/styles/b_style.dart';

PageController _controller = PageController();
const _kDuration = Duration(milliseconds: 300);
const _kCurve = Curves.ease;
int _index = 0;

class CreateAdScreen extends StatefulWidget {
  const CreateAdScreen({Key? key}) : super(key: key);

  @override
  _CreateAdScreenState createState() => _CreateAdScreenState();
}

class _CreateAdScreenState extends State<CreateAdScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: KColor.appBackground,
      navigationBar: KCupertinoNavBar(
        title: 'Create Ad',
        automaticallyImplyLeading: false,
        customLeading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Text('Close', style: KTextStyle.subtitle1.copyWith(color: KColor.closeText)),
          ),
        ),
      ),
      child: Column(
        children: [
          SizedBox(height: KSize.getHeight(context, 10)),
          Row(
            children: [
              SizedBox(width: KSize.getWidth(context, 15)),
              CircleAvatar(
                radius: 12,
                backgroundColor: KColor.primary,
                child: Icon(FontAwesome.check, size: 15, color: KColor.white),
              ),
              SizedBox(width: KSize.getWidth(context, 5)),
              Text('Details', style: KTextStyle.button.copyWith(fontWeight: FontWeight.w600, height: 1.2)),
              SizedBox(width: KSize.getWidth(context, 10)),
              Expanded(
                child: Container(
                  height: 1.5,
                  color: _index == 0 ? KColor.grey350 : KColor.primary,
                ),
              ),
              SizedBox(width: KSize.getWidth(context, 10)),
              CircleAvatar(
                radius: 12,
                backgroundColor: _index == 0 ? KColor.grey300 : KColor.primary,
                child: Icon(FontAwesome.check, size: 15, color: _index == 0 ? KColor.grey : KColor.white),
              ),
              SizedBox(width: KSize.getWidth(context, 5)),
              Text('Media', style: KTextStyle.button.copyWith(fontWeight: FontWeight.w600, height: 1.2)),
              SizedBox(width: KSize.getWidth(context, 15)),
            ],
          ),
          SizedBox(height: KSize.getHeight(context, 15)),
          Expanded(
            child: PageView.builder(
              itemBuilder: (context, position) {
                print('pos $position');
                return position == 0 ? const CreateAdDetailsView() : const CreateAdMediaView();
              },
              controller: _controller,
              itemCount: 2,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (index) {
                setState(() {
                  _index = index;
                });
                print('page - $index');
              },
            ),
          ),
        ],
      ),
    );
  }
}

/*
  * PageView 1
*/
class CreateAdDetailsView extends StatefulWidget {
  const CreateAdDetailsView({Key? key}) : super(key: key);

  @override
  _CreateAdDetailsViewState createState() => _CreateAdDetailsViewState();
}

class _CreateAdDetailsViewState extends State<CreateAdDetailsView> {
  TextEditingController pageController = TextEditingController();
  TextEditingController feedController = TextEditingController();
  TextEditingController textController = TextEditingController();
  TextEditingController eventStartDateController = TextEditingController();
  TextEditingController eventStartTimeController = TextEditingController();
  TextEditingController eventEndDateController = TextEditingController();
  TextEditingController eventEndTimeController = TextEditingController();

  bool _isAgreed = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Campaign name', style: KTextStyle.subtitle1.copyWith(fontWeight: FontWeight.bold)),
            KTextField(hintText: 'Your campaign name', controller: pageController, topMargin: KSize.getHeight(context, 10)),
            SizedBox(height: KSize.getHeight(context, 20)),
            Text('Budget', style: KTextStyle.subtitle1.copyWith(fontWeight: FontWeight.bold)),
            KTextField(
              hintText: 'Budget',
              controller: feedController,
              textInputType: TextInputType.number,
              topMargin: KSize.getHeight(context, 10),
            ),
            SizedBox(height: KSize.getHeight(context, 20)),
            Text('Start Date', style: KTextStyle.subtitle1.copyWith(fontWeight: FontWeight.bold)),
            KTextField(
              hintText: 'Start Date',
              controller: eventStartDateController,
              isReadOnly: true,
              suffixIcon: Icon(Icons.date_range, color: KColor.primary),
              topMargin: KSize.getHeight(context, 10),
              onTap: () => DateTimeService.pickDate(context, isFirstNow: true),
            ),
            SizedBox(height: KSize.getHeight(context, 20)),
            Text('End Date', style: KTextStyle.subtitle1.copyWith(fontWeight: FontWeight.bold)),
            KTextField(
              hintText: 'End Date',
              controller: eventEndDateController,
              isReadOnly: true,
              suffixIcon: Icon(Icons.date_range, color: KColor.primary),
              topMargin: KSize.getHeight(context, 10),
              onTap: () => DateTimeService.pickDate(context, isFirstNow: true),
            ),
            SizedBox(height: KSize.getHeight(context, 20)),
            Text('Destination URL', style: KTextStyle.subtitle1.copyWith(fontWeight: FontWeight.bold)),
            KTextField(
              hintText: 'Destination URL',
              controller: feedController,
              textInputType: TextInputType.url,
              topMargin: KSize.getHeight(context, 10),
            ),
            SizedBox(height: KSize.getHeight(context, 5)),
            InkWell(
              onTap: () {
                setState(() {
                  _isAgreed = !_isAgreed;
                });
              },
              child: Align(
                alignment: Alignment.center,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Checkbox(
                        value: _isAgreed,
                        onChanged: (val) {
                          setState(() {
                            _isAgreed = !_isAgreed;
                          });
                        }),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'I agree with the ',
                            style: KTextStyle.bodyText3.copyWith(color: KColor.black87),
                          ),
                          TextSpan(
                            text: 'Advertising Policies.',
                            style: KTextStyle.bodyText3.copyWith(color: KColor.primary, fontWeight: FontWeight.w600),
                            recognizer: TapGestureRecognizer()..onTap = () {},
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: KSize.getWidth(context, 15)),
                  ],
                ),
              ),
            ),
            SizedBox(height: KSize.getHeight(context, 15)),
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: KSize.getWidth(context, 120),
                child: KButton(
                  title: 'Next',
                  innerPadding: 9,
                  onPressedCallback: () {
                    _controller.nextPage(duration: _kDuration, curve: _kCurve);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/*
  * PageView 2
*/
class CreateAdMediaView extends StatefulWidget {
  const CreateAdMediaView({Key? key}) : super(key: key);

  @override
  _CreateAdMediaViewState createState() => _CreateAdMediaViewState();
}

class _CreateAdMediaViewState extends State<CreateAdMediaView> {
  TextEditingController pageController = TextEditingController();
  TextEditingController feedController = TextEditingController();
  TextEditingController textController = TextEditingController();
  TextEditingController aboutController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Page', style: KTextStyle.subtitle1.copyWith(fontWeight: FontWeight.bold)),
            KTextField(hintText: 'Page', controller: pageController, topMargin: KSize.getHeight(context, 10)),
            SizedBox(height: KSize.getHeight(context, 20)),
            Text('Feed', style: KTextStyle.subtitle1.copyWith(fontWeight: FontWeight.bold)),
            KTextField(
              hintText: 'Feed',
              controller: feedController,
              textInputType: TextInputType.number,
              topMargin: KSize.getHeight(context, 10),
            ),
            SizedBox(height: KSize.getHeight(context, 20)),
            Text('Text', style: KTextStyle.subtitle1.copyWith(fontWeight: FontWeight.bold)),
            KTextField(hintText: 'Text', controller: pageController, topMargin: KSize.getHeight(context, 10)),
            SizedBox(height: KSize.getHeight(context, 20)),
            Text('Short Description', style: KTextStyle.subtitle1.copyWith(fontWeight: FontWeight.bold)),
            KTextField(
              hintText: 'Short Description',
              maxLines: null,
              minLines: 5,
              topMargin: KSize.getHeight(context, 10),
              controller: aboutController,
            ),
            SizedBox(height: KSize.getHeight(context, 20)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    _controller.previousPage(duration: _kDuration, curve: _kCurve);
                  },
                  child: Row(
                    children: [
                      Icon(
                        Entypo.arrow_long_left,
                        size: 20,
                        color: KColor.black,
                      ),
                      SizedBox(width: KSize.getWidth(context, 5)),
                      Text(
                        'Go Back',
                        style: KTextStyle.button.copyWith(fontWeight: FontWeight.w600, height: 1.2),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: KSize.getWidth(context, 10)),
                SizedBox(
                  width: KSize.getWidth(context, 120),
                  child: KButton(
                    title: 'Create',
                    innerPadding: 9,
                    onPressedCallback: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
