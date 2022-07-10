import 'package:buddyscripts/services/app_mode.dart';
import 'package:flutter/material.dart';
import 'package:buddyscripts/views/styles/b_style.dart';
import 'package:flutter/services.dart';

// ignore: must_be_immutable
class KTextField extends StatefulWidget {
  final String? hintText;
  final Color? hintColor;
  final TextStyle? hintStyle;
  final String? labelText;
  final TextStyle? style;
  final Icon? suffixIcon;
  final Icon? prefixIcon;
  final bool hasPrefixIcon;
  final bool isPasswordField;
  final TextEditingController? controller;
  final TextInputType textInputType;
  final TextAlign textAlign;
  final TextInputAction textInputAction;
  final double widthFactor;
  final bool isReadOnly;
  final int? maxLength;
  final bool maxLengthEnforced;
  final Function()? onTap;
  final int? maxLines;
  final int? minLines;
  final double topMargin;
  final double borderRadius;
  final bool isClearableField;
  final FormFieldValidator? validator;
  String? errorMessage;
  final Function(String value)? callBackFunction;
  final bool callBack;
  final Color backgroundColor;
  final LinearGradient? gredientColor;
  final Color textColor;
  final bool suffixCallback;
  final Function()? suffixCallbackFunction;
  final bool autofocus;
  final List<TextInputFormatter>? inputFormatters;
  final bool widgetInTextField;
  final Widget? childWidgetView;
  final double? contentPaddingHorizental;
  final double? contentPaddingVerticle;

  KTextField({
    Key? key,
    this.hintText,
    this.hintColor,
    this.hintStyle,
    this.labelText,
    this.style,
    this.suffixIcon,
    this.prefixIcon,
    this.hasPrefixIcon = false,
    this.isPasswordField = false,
    this.controller,
    this.widthFactor = 1,
    this.textAlign = TextAlign.left,
    this.textInputType = TextInputType.text,
    this.textInputAction = TextInputAction.done,
    this.isReadOnly = false,
    this.maxLength,
    this.maxLengthEnforced = false,
    this.onTap,
    this.maxLines = 1,
    this.minLines = 1,
    this.topMargin = 20.0,
    this.borderRadius = 6.0,
    this.isClearableField = false,
    this.validator,
    this.errorMessage,
    this.callBack = false,
    this.callBackFunction,
    this.backgroundColor = KColor.blackConst,
    this.gredientColor,
    this.textColor = KColor.blackConst,
    this.suffixCallback = false,
    this.suffixCallbackFunction,
    this.autofocus = false,
    this.inputFormatters,
    this.widgetInTextField = false,
    this.childWidgetView,
    this.contentPaddingHorizental,
    this.contentPaddingVerticle = 16,
  }) : super(key: key);

  @override
  _KTextFieldState createState() => _KTextFieldState();
}

class _KTextFieldState extends State<KTextField> {
  bool _isClearableText = false;
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * widget.widthFactor,
      padding: EdgeInsets.symmetric(horizontal: KSize.getWidth(context, 10)),
      margin: EdgeInsets.only(top: KSize.getHeight(context, widget.topMargin)),
      decoration: BoxDecoration(
        gradient: widget.gredientColor,
        color: widget.backgroundColor == KColor.blackConst
            ? AppMode.darkMode
                ? KColor.appBackground
                : KColor.white
            : widget.backgroundColor,
        boxShadow: [BoxShadow(color: KColor.white.withOpacity(0.1), blurRadius: 2, spreadRadius: 0, offset: const Offset(0, 1))],
        border: Border.all(
          color: widget.errorMessage == null
              ? KColor.grey
              : widget.errorMessage == ''
                  ? KColor.grey
                  : KColor.red!,
          width: 0.7,
          style: widget.errorMessage == null || widget.errorMessage == '' ? BorderStyle.none : BorderStyle.solid,
        ),
        borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            validator: (String? value) {
              setState(() {
                print("value");
                print(value);
                print(widget.validator);
                widget.errorMessage = widget.validator == null ? "" : widget.validator!(value);
              });
              print('errorMessage =  ${widget.errorMessage}');
              return widget.errorMessage == null || widget.errorMessage!.isEmpty ? null : widget.errorMessage;
            },
            inputFormatters: widget.inputFormatters ?? [],
            controller: widget.controller,
            readOnly: widget.isReadOnly,
            maxLength: widget.maxLengthEnforced ? widget.maxLength : null,
            // ignore: deprecated_member_use
            maxLengthEnforced: widget.maxLengthEnforced,
            maxLines: widget.maxLines,
            minLines: widget.minLines,
            cursorColor: KColor.grey,
            keyboardType: widget.textInputType,
            textInputAction: widget.textInputAction,
            style: widget.style ?? KTextStyle.bodyText1.copyWith(color: widget.textColor == KColor.blackConst ? KColor.black87 : widget.textColor),
            obscureText: widget.isPasswordField ? _obscureText : false,
            textAlignVertical: TextAlignVertical.center,
            textAlign: widget.textAlign,
            autofocus: widget.autofocus,
            decoration: InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.symmetric(vertical: widget.contentPaddingVerticle ?? 8, horizontal: widget.contentPaddingHorizental ?? 0),
              labelText: widget.labelText,
              labelStyle: KTextStyle.bodyText3.copyWith(color: KColor.black54),
              hintText: widget.hintText,
              hintStyle: widget.hintStyle ?? KTextStyle.bodyText3.copyWith(color: widget.hintColor ?? (KColor.black54)),
              errorStyle: const TextStyle(fontSize: 0, height: 0),
              border: InputBorder.none,
              prefixIcon: widget.hasPrefixIcon
                  ? Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: widget.prefixIcon,
                    )
                  : Padding(
                      padding: EdgeInsetsDirectional.only(
                        start: widget.hasPrefixIcon ? 0.0 : widget.contentPaddingHorizental ?? 0,
                        end: widget.hasPrefixIcon ? 0.0 : widget.contentPaddingHorizental ?? 0,
                      ),
                    ),
              prefixIconConstraints: BoxConstraints(minHeight: widget.hasPrefixIcon ? 48 : 0),
              suffixIcon: widget.isPasswordField
                  ? obscureText()
                  : widget.isClearableField
                      ? clearField()
                      : widget.suffixIcon,
            ),
            onTap: widget.onTap,
            onChanged: (val) {
              if (val != '') {
                if (!_isClearableText) {
                  setState(() {
                    _isClearableText = true;
                  });
                } else if (widget.errorMessage != null) {
                  setState(() {
                    widget.errorMessage = null;
                  });
                }
              } else {
                setState(() {
                  _isClearableText = false;
                });
              }

              /// Search query
              if (widget.callBack) {
                widget.callBackFunction!(val);
              }
            },
          ),
          Visibility(
              visible: widget.widgetInTextField,
              child: Container(padding: const EdgeInsets.symmetric(vertical: 15), child: widget.childWidgetView ?? Container())),
        ],
      ),
    );
  }

  GestureDetector obscureText() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _obscureText = !_obscureText;
        });
      },
      child: Icon(
        /// Based on password visibility state choose the icon
        !_obscureText ? Icons.visibility : Icons.visibility_off,
        size: 18.0,
        color: KColor.primary,
      ),
    );
  }

  GestureDetector clearField() {
    return GestureDetector(
      onTap: () {
        widget.controller?.clear();
        setState(() {
          _isClearableText = false;
        });
        if (widget.suffixCallback) {
          widget.suffixCallbackFunction!();
        }
      },
      child: Icon(
        Icons.cancel,
        color: _isClearableText ? KColor.black54 : KColor.transparent,
        size: 16.0,
      ),
    );
  }
}
