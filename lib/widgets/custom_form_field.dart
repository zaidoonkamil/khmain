import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomFormField extends StatelessWidget {
  CustomFormField(
      {Key? key,
        this.hintText,
        this.textInputType,
        this.width,
        this.validate,
        this.suffix,
        this.controller,
        this.textAlign,
        this.obscureText = false
      }) : super(key: key);

  String? hintText;
  TextEditingController? controller;
  String? Function(String?)? validate;
  double? width;
  bool? obscureText;
  TextInputType? textInputType;
  TextAlign? textAlign;
  Widget? suffix;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: width,
          decoration: BoxDecoration(
            color: Theme.of(context).dividerColor,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal:23 ),
            child: TextFormField(
              style: TextStyle(
                  // color:Theme.of(context).inputDecorationTheme.labelStyle!.color,
                  fontWeight: FontWeight.bold
              ),
              controller: controller,
              keyboardType:textInputType?? TextInputType.text ,
              textAlign:textAlign?? TextAlign.right,
              textAlignVertical: TextAlignVertical.bottom,
              obscureText: obscureText!,
              validator: validate,
              decoration: InputDecoration(
                hintText: hintText,
                enabledBorder: InputBorder.none,
                border: InputBorder.none,

              ),
            ),
          ),
        ),
      ],
    );
  }
}
