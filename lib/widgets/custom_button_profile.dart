import 'package:flutter/material.dart';

import 'constant.dart';


class CustomButtonProfile extends StatelessWidget {
  const CustomButtonProfile({
    Key? key,
    required this.onPressed,
  }) : super(key: key);
  final Function() onPressed;


  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60,
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: FloatingActionButton.extended(
        backgroundColor: KprimaryColor,
        label: Text(
          'الخروج من اللعة',
          style: TextStyle(color: KprimaryScafoldColor),
        ),
        icon:  Icon(
          Icons.exit_to_app,
          color: KprimaryScafoldColor,
          size: 30,
        ),
        onPressed: onPressed,
      ),
    );
  }
}
