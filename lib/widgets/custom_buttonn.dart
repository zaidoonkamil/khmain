import 'package:flutter/material.dart';

import 'constant.dart';

class CustomBottomm extends StatelessWidget {
  final String text;
  final double roundness;
  final double? horizontal;
  final double? vertical;
  final FontWeight fontWeight;
  final VoidCallback? onTap;
  final Color? colorText;
  final Color colorBottom;
  final Color? colorBorderBottom;
  final double? fontSize;
  final double? sizeCircular;
  final double? width;
  final double? height;
  final TextAlign? textAlign;
  final BorderRadius? borderRadius;

  const CustomBottomm({
    Key? key,
    required this.text,
    this.roundness = 18,
    this.fontWeight = FontWeight.bold,
    this.onTap,
    this.colorText,
    this.fontSize,
    required this.colorBottom,
    this.width,
    this.height,
    this.sizeCircular,
    this.horizontal,
    this.vertical,
    this.borderRadius,
    this.colorBorderBottom, this.textAlign,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: horizontal??0,vertical:vertical??0 ),
        decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: colorBorderBottom ?? colorBottom
            ),
          color: colorBottom,
          borderRadius:borderRadius?? BorderRadius.circular(sizeCircular??20)  ,
        ),
        width: width,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  text,
                  style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: fontWeight,
                      color: colorText
                  ),
                  textAlign: textAlign,
                ),
                const SizedBox(width: 6,),
                Icon(Icons.arrow_forward_ios,color: KprimaryScafoldColor,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
