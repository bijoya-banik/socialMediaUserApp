import 'dart:io';

import 'package:buddyscripts/controller/event/my_events_controller.dart';
import 'package:buddyscripts/controller/event/state/my_events_state.dart';
import 'package:buddyscripts/models/event/event_feed_model.dart';
import 'package:buddyscripts/services/asset_service.dart';
import 'package:buddyscripts/services/validator.dart';
import 'package:buddyscripts/views/global_components/dialogs/k_dialog.dart';
import 'package:buddyscripts/views/global_components/dialogs/processing_dialog_content.dart';
import 'package:buddyscripts/views/global_components/k_date_time_picker_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:buddyscripts/views/global_components/k_cupertino_nav_bar.dart';
import 'package:buddyscripts/views/global_components/k_text_field.dart';
import 'package:buddyscripts/views/styles/b_style.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateEventScreen extends StatefulWidget {
  final bool isEdit;
  final BasicOverView? eventData;

  const CreateEventScreen({Key? key, this.eventData, this.isEdit = false}) : super(key: key);

  @override
  _CreateEventScreenState createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  TextEditingController eventTitleController = TextEditingController();
  TextEditingController eventLocationController = TextEditingController();
  TextEditingController eventDescriptionController = TextEditingController();
  TextEditingController eventStartDateController = TextEditingController();
  TextEditingController eventEndDateController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  File? pickedBanner;

  @override
  void initState() {
    super.initState();
    if (widget.isEdit) {
      eventTitleController.text = widget.eventData!.eventName!;
      eventLocationController.text = widget.eventData!.address ?? '';
      eventDescriptionController.text = widget.eventData!.about ?? '';
      eventStartDateController.text = widget.eventData!.startTime!.toIso8601String();
      eventEndDateController.text = widget.eventData!.endTime!.toIso8601String();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final myEventState = ref.watch(myEventsProvider);

      ref.listen(myEventsProvider, (_, state) {
        if (state is MyEventsSuccessState) {
          Navigator.pop(context);
        }
      });
      return CupertinoPageScaffold(
        backgroundColor: KColor.darkAppBackground,
        navigationBar: KCupertinoNavBar(
          title: widget.isEdit ? 'Edit Event' : 'Create Event',
          automaticallyImplyLeading: false,
          customLeading: InkWell(
            onTap: () => Navigator.pop(context),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Text('Close', style: KTextStyle.subtitle1.copyWith(color: KColor.closeText)),
            ),
          ),
          trailing: InkWell(
            onTap: () async {
              if (_formKey.currentState!.validate()) {
                if (myEventState is! MyEventsLoadingState) {
                  KDialog.kShowDialog(context, const ProcessingDialogContent("Please wait..."), barrierDismissible: false);
                  FocusScope.of(context).unfocus();
                  if (widget.isEdit) {
                    await ref.read(myEventsProvider.notifier).editEvent(
                          id: widget.eventData!.id,
                          eventName: eventTitleController.text,
                          address: eventLocationController.text,
                          startTime: eventStartDateController.text,
                          endTime: eventEndDateController.text,
                          about: eventDescriptionController.text,
                        );
                  } else {
                    await ref.read(myEventsProvider.notifier).createEvent(
                        eventName: eventTitleController.text,
                        address: eventLocationController.text,
                        startTime: eventStartDateController.text,
                        endTime: eventEndDateController.text,
                        about: eventDescriptionController.text,
                        cover: pickedBanner == null ? null : [pickedBanner]);
                  }

                  Navigator.pop(context);
                }
              }
            },
            child: Text(
              widget.isEdit ? 'UPDATE' : 'CREATE',
              style: KTextStyle.subtitle2.copyWith(color: KColor.black, fontWeight: FontWeight.w700),
            ),
          ),
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Title', style: KTextStyle.subtitle1.copyWith(color: KColor.black, fontWeight: FontWeight.bold)),
                      KTextField(
                        hintText: 'Your event title',
                        controller: eventTitleController,
                        topMargin: KSize.getHeight(context, 10),
                        validator: (v) => Validators.fieldValidator(v),
                      ),
                      SizedBox(height: KSize.getHeight(context, 20)),
                      Text('Location', style: KTextStyle.subtitle1.copyWith(color: KColor.black, fontWeight: FontWeight.bold)),
                      KTextField(
                        hintText: 'Location or Online',
                        controller: eventLocationController,
                        topMargin: KSize.getHeight(context, 10),
                        validator: (v) => Validators.fieldValidator(v),
                      ),
                      SizedBox(height: KSize.getHeight(context, 20)),
                      Text('Event start', style: KTextStyle.subtitle1.copyWith(color: KColor.black, fontWeight: FontWeight.bold)),
                      KDateTimePickerField(
                        dateHint: 'Select date and time',
                        controller: eventStartDateController,
                        topMargin: KSize.getHeight(context, 10),
                        dateTimePickerType: 'datetime',
                        //  validator: (value) => Validators.fieldValidator(value),
                      ),
                      SizedBox(height: KSize.getHeight(context, 20)),
                      Text('Event end', style: KTextStyle.subtitle1.copyWith(color: KColor.black, fontWeight: FontWeight.bold)),
                      KDateTimePickerField(
                        dateHint: 'Select date and time',
                        controller: eventEndDateController,
                        topMargin: KSize.getHeight(context, 10),
                        dateTimePickerType: 'datetime',
                        //validator: (value) => Validators.fieldValidator(value),
                      ),
                      SizedBox(height: KSize.getHeight(context, 20)),
                      Text('Description', style: KTextStyle.subtitle1.copyWith(color: KColor.black, fontWeight: FontWeight.bold)),
                      KTextField(
                        hintText: 'Enter details',
                        maxLines: null,
                        minLines: 7,
                        topMargin: KSize.getHeight(context, 10),
                        controller: eventDescriptionController,
                        //  validator: (v) => Validators.fieldValidator(v),
                      ),
                      SizedBox(height: KSize.getHeight(context, 20)),
                    ],
                  ),
                ),
                Text('Cover picture', style: KTextStyle.subtitle1.copyWith(color: KColor.black, fontWeight: FontWeight.bold)),
                SizedBox(height: KSize.getHeight(context, 10)),
                Stack(
                  children: [
                    InkWell(
                      onTap: () async {
                        dynamic pickedFile;
                        pickedFile = await AssetService.pickMedia(true, context, false, true);

                        if (pickedFile != null) {
                          setState(() {
                            pickedBanner = pickedFile;
                          });
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 30),
                        height: 180,
                        decoration: BoxDecoration(
                            color: KColor.textBackground,
                            boxShadow: [
                              BoxShadow(color: KColor.white.withOpacity(0.1), blurRadius: 2, spreadRadius: 0, offset: const Offset(0, 1)),
                            ],
                            borderRadius: BorderRadius.circular(10)),
                        child: pickedBanner == null
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.camera_alt_outlined, color: KColor.grey),
                                  SizedBox(width: KSize.getWidth(context, 8)),
                                  Text('Add cover photo',
                                      textAlign: TextAlign.center, style: KTextStyle.subtitle1.copyWith(color: KColor.grey.withOpacity(0.7))),
                                ],
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.file(
                                  File(pickedBanner!.path),
                                  height: 120,
                                  width: MediaQuery.of(context).size.width - 40,
                                  fit: BoxFit.cover,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
