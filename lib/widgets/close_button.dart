import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:khamin/view/home_screen.dart';

import 'constant.dart';

class CustomCloseButton extends StatelessWidget {
   const CustomCloseButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: KprimarySupTextColor),
          ),
          child: InkWell(
            onTap: () {
             Get.offAll(const HomeScreen());
            },
            child:  Icon(
              Icons.close_rounded,
              color: KprimarySupTextColor ,
              size: 30,
            ),
          ),
        ),
      ],
    );
  }
}
