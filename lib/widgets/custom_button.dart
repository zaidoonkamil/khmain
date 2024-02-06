import 'package:flutter/material.dart';

import 'constant.dart';


class CustomButton extends StatelessWidget {
  const CustomButton({
    Key? key,
    required this.onPressed,
    required this.text,
  }) : super(key: key);
  final Function() onPressed;
  final String text;


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: FloatingActionButton.extended(
        backgroundColor: KprimaryColor,
        label: Text(
          text,
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
