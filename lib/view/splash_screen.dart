import 'package:flutter/material.dart';
import 'package:khamin/local/cache_helper.dart';
import 'package:khamin/view/home_screen.dart';
import 'package:khamin/widgets/navigation.dart';
import 'package:lottie/lottie.dart';
import 'package:get/get.dart';

import 'welcome_screen.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key,}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 3), () {
      if(CacheHelper.getData(key: 'name') != null){
        navigateAndFinish(context, const HomeScreen());
      }else{
        navigateAndFinish(context, const WelcomeScreen());

      }
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: Center(
            child: SizedBox(
              width: Get.width * 0.75,
              height: Get.width * 0.75,
              child: Lottie.asset("assets/lottie/animation_lm4vejbf.json"),
            ),
          ),
        ),
      ),
    );
  }
}
