import 'package:buddyscripts/views/global_components/k_text_field.dart';
import 'package:buddyscripts/views/styles/b_style.dart';
import 'package:flutter/material.dart';

class PollOptionField extends StatefulWidget {
  const PollOptionField({Key? key, required this.pollOptionsController, required this.index, this.removeFieldCallback, this.showRemoveOption = false})
      : super(key: key);
  final int index;
  final List<TextEditingController> pollOptionsController;
  final Function()? removeFieldCallback;
  final bool showRemoveOption;

  @override
  State<PollOptionField> createState() => _PollOptionFieldState();
}

class _PollOptionFieldState extends State<PollOptionField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(border: Border.all(color: KColor.black45, width: 0.6), borderRadius: BorderRadius.circular(4)),
                  child: KTextField(
                    topMargin: 0,
                    contentPaddingVerticle: 2,
                    hintText: 'Option ${widget.index + 1}',
                    controller: widget.pollOptionsController[widget.index],
                  ),
                ),
              ),
              if (widget.showRemoveOption)
                InkWell(
                  onTap: () {
                    widget.removeFieldCallback!();
                    print('object');
                  },
                  child: Icon(Icons.close, color: KColor.grey700),
                ),
              SizedBox(width: KSize.getWidth(context, 12)),
            ],
          ),
        ],
      ),
    );
  }
}
