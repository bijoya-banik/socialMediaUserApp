import 'package:buddyscripts/controller/auth/user_controller.dart';
import 'package:buddyscripts/controller/profile/profile_about_controller.dart';
import 'package:buddyscripts/models/profile/profile_overview_model.dart';
import 'package:buddyscripts/services/validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:buddyscripts/services/date_time_service.dart';
import 'package:buddyscripts/views/global_components/k_cupertino_nav_bar.dart';
import 'package:buddyscripts/views/global_components/k_text_field.dart';
import 'package:buddyscripts/views/styles/b_style.dart';

class WorkAddEditScreen extends ConsumerStatefulWidget {
  final bool isEdit;
  final WorkDatum? workData;
  final int? index;
  const WorkAddEditScreen({Key? key, this.isEdit = true, this.workData, this.index}) : super(key: key);

  @override
  _WorkAddEditScreenState createState() => _WorkAddEditScreenState();
}

class _WorkAddEditScreenState extends ConsumerState<WorkAddEditScreen> {
  TextEditingController companyNameController = TextEditingController();
  TextEditingController positionController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isCurrentlyWorking = false;
  dynamic startDate;

  @override
  void initState() {
    if (widget.isEdit) setWorkData();
    super.initState();
  }

  setWorkData() {
    companyNameController.text = widget.workData?.comapnyName ?? '';
    positionController.text = widget.workData?.position ?? '';
    startDateController.text = widget.workData?.startingDate;
    endDateController.text = widget.workData?.endingDate;
    _isCurrentlyWorking = widget.workData!.isCurrentlyWorking!;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: KColor.darkAppBackground,
      navigationBar: KCupertinoNavBar(
        title: 'Work',
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
              // KDialog.kShowDialog(
              //   context,
              //   const ProcessingDialogContent("Processing..."),
              //   barrierDismissible: false,
              // );
              List<WorkDatum>? workDatum = ref.read(profileAboutProvider.notifier).myProfileOverviewModel!.basicOverView!.workData;

              if (widget.isEdit) {
                workDatum![widget.index!] = WorkDatum(
                  comapnyName: companyNameController.text,
                  position: positionController.text,
                  startingDate: startDateController.text,
                  endingDate: endDateController.text,
                  isCurrentlyWorking: _isCurrentlyWorking,
                );
              } else {
                workDatum!.add(WorkDatum(
                  comapnyName: companyNameController.text,
                  position: positionController.text,
                  startingDate: startDateController.text,
                  endingDate: endDateController.text,
                  isCurrentlyWorking: _isCurrentlyWorking,
                ));
              }

              await ref.read(userProvider.notifier).updateUserData(workData: workDatum, isWorkUpdate: true);
              Navigator.pop(context);
            }
          },
          child: Text(
            widget.isEdit ? 'UPDATE' : 'ADD',
            style: KTextStyle.subtitle2.copyWith(color: KColor.black, fontWeight: FontWeight.w700),
          ),
        ),
      ),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Company', style: KTextStyle.subtitle1.copyWith(fontWeight: FontWeight.bold, color: KColor.black)),
                KTextField(
                  hintText: 'Company',
                  controller: companyNameController,
                  topMargin: KSize.getHeight(context, 10),
                  validator: (v) => Validators.fieldValidator(v),
                ),
                SizedBox(height: KSize.getHeight(context, 20)),
                Text('Position', style: KTextStyle.subtitle1.copyWith(fontWeight: FontWeight.bold, color: KColor.black)),
                KTextField(
                  hintText: 'Position',
                  controller: positionController,
                  topMargin: KSize.getHeight(context, 10),
                  validator: (v) => Validators.fieldValidator(v),
                ),
                SizedBox(height: KSize.getHeight(context, 20)),
                Text('Start Date', style: KTextStyle.subtitle1.copyWith(fontWeight: FontWeight.bold, color: KColor.black)),
                KTextField(
                  hintText: 'Start Date',
                  controller: startDateController,
                  isReadOnly: true,
                  suffixIcon: Icon(Icons.date_range, color: KColor.primary),
                  topMargin: KSize.getHeight(context, 10),
                  onTap: () async {
                    DateTime picked = await DateTimeService.pickDate(context, isFirstNow: true, initialDate: DateTime.now());

                    startDate = picked;

                    setState(() {
                      startDateController.text = DateTimeService.convert(picked).toString();
                      endDateController.text = '';
                    });
                  },
                  validator: (v) => Validators.fieldValidator(v),
                ),
                SizedBox(height: KSize.getHeight(context, 20)),
                InkWell(
                  onTap: () {
                    setState(() {
                      _isCurrentlyWorking = !_isCurrentlyWorking;
                    });
                  },
                  child: Row(
                    children: [
                      Icon(
                        !_isCurrentlyWorking ? Icons.check_box_outline_blank_outlined : Icons.check_box,
                        color: KColor.primary,
                      ),
                      SizedBox(width: KSize.getWidth(context, 5)),
                      Text(
                        'I am currently working here',
                        style: KTextStyle.bodyText3.copyWith(color: KColor.black87),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: KSize.getHeight(context, 16)),
                if (!_isCurrentlyWorking)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('End Date', style: KTextStyle.subtitle1.copyWith(fontWeight: FontWeight.bold, color: KColor.black)),
                      KTextField(
                        hintText: 'End Date',
                        controller: endDateController,
                        isReadOnly: true,
                        suffixIcon: Icon(Icons.date_range, color: KColor.primary),
                        topMargin: KSize.getHeight(context, 10),
                        onTap: () async {
                          DateTime picked = await DateTimeService.pickDate(
                            context,
                            isFirstNow: true,
                            firstDate: startDate,
                            initialDate: endDateController.text.isNotEmpty ? DateTime.parse(endDateController.text) : null,
                          );
                          setState(() {
                            endDateController.text = DateTimeService.convert(picked).toString();
                          });
                        },
                        validator: (v) => !_isCurrentlyWorking ? Validators.fieldValidator(v) : null,
                      ),
                      SizedBox(height: KSize.getHeight(context, 20)),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
