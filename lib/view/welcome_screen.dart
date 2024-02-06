import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:khamin/local/cache_helper.dart';
import 'package:khamin/widgets/constant.dart';
import 'package:khamin/widgets/custom_buttonn.dart';
import 'package:khamin/widgets/custom_form_field.dart';
import 'package:khamin/widgets/navigation.dart';
import 'package:lottie/lottie.dart';

import 'home_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  static GlobalKey<FormState> formKey = GlobalKey<FormState>();
  static TextEditingController userNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: Get.width * 0.75,
                  height: Get.width * 0.75,
                  child: Lottie.asset("assets/lottie/animation_lm4vejbf.json"),
                ),
                CustomFormField(
                  controller: userNameController,
                  validate: (String? value) {
                    if (value!.isEmpty) {
                      return 'رجائا ادخل الاسم';
                    }
                  },
                  hintText: 'الاسم',
                ),
                const SizedBox(height: 20,),
                CustomBottomm(
                  borderRadius: BorderRadius.circular(16),
                  horizontal: 10,
                  vertical: 12,
                  fontSize: 16,
                  colorText: KprimaryScafoldColor,
                  fontWeight: FontWeight.bold,
                  text: 'التالي',
                  colorBottom: KprimaryColor,
                  onTap: (){
                    if (formKey.currentState!.validate()) {
                      CacheHelper.saveData(key:'name',value: userNameController.text);
                      navigateAndFinish(context, const HomeScreen());

                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
