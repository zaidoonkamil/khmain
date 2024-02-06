import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:khamin/controllers/quiz_controller.dart';
import 'package:khamin/local/cache_helper.dart';
import 'package:khamin/view/quiz_screen.dart';
import 'package:khamin/widgets/constant.dart';
import 'package:khamin/widgets/custom_buttonn.dart';
import 'package:khamin/widgets/navigation.dart';
import 'package:lottie/lottie.dart';
import 'package:share/share.dart';

import '../widgets/custom_form_field.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  BannerAd? _anchoredAdaptiveAd;
  bool _isLoaded = false;
  late Orientation _currentOrientation;
  InterstitialAd? interstitialAd;
  static GlobalKey<FormState> formKey = GlobalKey<FormState>();
  static TextEditingController nameController = TextEditingController();

  void interstitial() {
    InterstitialAd.load(
      adUnitId: interstitialId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          interstitialAd = ad;
          ad.show();
          interstitialAd?.fullScreenContentCallback =
              FullScreenContentCallback(onAdDismissedFullScreenContent: (ad) {
            interstitialAd?.dispose();
            ad.dispose();
          }, onAdFailedToShowFullScreenContent: (ad, err) {
            ad.dispose();
            interstitialAd?.dispose();
          });
        },
        onAdFailedToLoad: (err) {
          interstitialAd?.dispose();
        },
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _currentOrientation = MediaQuery.of(context).orientation;
    _loadAd();
  }

  Future<void> _loadAd() async {
    await _anchoredAdaptiveAd?.dispose();
    setState(() {
      _anchoredAdaptiveAd = null;
      _isLoaded = false;
    });

    _anchoredAdaptiveAd = BannerAd(
      adUnitId: bannerId,
      size: AdSize.fullBanner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          print('$ad loaded: ${ad.responseInfo}');
          setState(() {
            _anchoredAdaptiveAd = ad as BannerAd;
            _isLoaded = true;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('Anchored adaptive banner failedToLoad: $error');
          ad.dispose();
        },
      ),
    );
    return _anchoredAdaptiveAd!.load();
  }

  Widget _getAdWidget() {
    return OrientationBuilder(
      builder: (context, orientation) {
        if (_currentOrientation == orientation &&
            _anchoredAdaptiveAd != null &&
            _isLoaded) {
          return Container(
            color: KprimaryScafoldColor,
            width: _anchoredAdaptiveAd!.size.width.toDouble(),
            height: _anchoredAdaptiveAd!.size.height.toDouble(),
            child: AdWidget(ad: _anchoredAdaptiveAd!),
          );
        }
        // Reload the ad if the orientation changes.
        if (_currentOrientation != orientation) {
          _currentOrientation = orientation;
          _loadAd();
        }
        return Container();
      },
    );
  }

  @override
  void initState() {
    interstitial();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: KprimaryScafoldColor,
        body: GetBuilder<NewQuizController>(
            init: NewQuizController(),
            builder: (controller) {
              return Stack(
                children: [
                  SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        Container(
                          height:50,
                          width: double.maxFinite,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text(
                                          'ادخل الاسم الجديد',
                                          textAlign: TextAlign.end,
                                        ),
                                        content: SizedBox(
                                          height: 150,
                                          child: Form(
                                            key: formKey,
                                            child: Column(
                                              children: [
                                                CustomFormField(
                                                  controller: nameController,
                                                  validate: (String? value) {
                                                    if (value!.isEmpty) {
                                                      return 'رجائا ادخل الاسم';
                                                    }
                                                  },
                                                  hintText: 'الاسم',
                                                  textInputType:
                                                  TextInputType.text,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        actions: [
                                          Padding(
                                            padding:
                                            const EdgeInsets.all(8.0),
                                            child: CustomBottomm(
                                              borderRadius: BorderRadius.circular(16),
                                              horizontal: 10,
                                              vertical: 12,
                                              fontSize: 16,
                                              colorText: KprimaryScafoldColor,
                                              fontWeight: FontWeight.bold,
                                              text: 'حفظ',
                                              colorBottom: KprimaryColor,
                                              onTap: (){
                                                if (formKey.currentState!.validate()) {
                                                  setState(() {

                                                  });
                                                  CacheHelper.saveData(key:'name',value: nameController.text);
                                                  navigateBack(context);
                                                }
                                              },
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: Container(
                                    height: double.maxFinite,
                                    width: 50,
                                    decoration: const BoxDecoration(
                                        color: KprimaryColor,
                                        borderRadius: BorderRadius.only(
                                            bottomRight: Radius.circular(10))),
                                    child: Icon(
                                      Icons.person,
                                      color: KprimaryScafoldColor,
                                    )),
                              ),
                              Row(
                                children: [
                                  Image.asset(
                                    "assets/images/ic_launcher_foreground.png",
                                    width: 50,
                                    height: 50,
                                  ),
                                  const Text(
                                    'خمن اللاعب',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: Colors.black),
                                  ),
                                ],
                              ),
                              GestureDetector(
                                onTap: () {
                                  Share.share('check out The beautiful game https://play.google.com/store/apps/details?id=com.zaidoon.alham', subject: 'Look what I made!');
                                },
                                child: Container(
                                    height: double.maxFinite,
                                    width: 54,
                                    decoration: const BoxDecoration(
                                        color: KprimaryColor,
                                        borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(10))),
                                    child: Icon(
                                      Icons.ios_share,
                                      color: KprimaryScafoldColor,
                                    )),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16),
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: (){
                                  CacheHelper.removeData(key: 'sports');
                                },
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.restart_alt,
                                      color: Colors.black,
                                    ),
                                    const Spacer(),
                                    Row(
                                      children: [
                                        Text(
                                          '${CacheHelper.getData(key: 'sports') ?? 0.toString()}',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 24,
                                              color: KprimaryColor),
                                        ),
                                        const Text(
                                          '  :اعلى نقاط  ',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                width: double.maxFinite,
                                decoration: BoxDecoration(
                                    color: KprimaryColor,
                                    borderRadius: BorderRadius.circular(16)),
                                child: Column(
                                  children: [
                                    Text(
                                      'مرحبا مجددا',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: KprimaryScafoldColor),
                                    ),
                                    Text(
                                      CacheHelper.getData(key: 'name').toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: KprimaryScafoldColor),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              Container(
                                // decoration: BoxDecoration(
                                //     color: KprimaryColor,
                                //     borderRadius: BorderRadius.circular(30)
                                // ),
                                width: Get.width * 0.75,
                                height: Get.width * 0.75,
                                child: Lottie.asset(
                                    "assets/lottie/animation_lm5dt7i2.json"),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              CustomBottomm(
                                borderRadius: BorderRadius.circular(16),
                                horizontal: 10,
                                vertical: 8,
                                fontSize: 20,
                                colorText: KprimaryScafoldColor,
                                fontWeight: FontWeight.bold,
                                text: 'هيا نبدأ اللعب',
                                colorBottom: KprimaryColor,
                                onTap: () {
                                  navigateAndFinish(
                                    context,
                                    QuizScreen(
                                      questions: controller.questionsSports,
                                      nameIndex: 'sports',
                                      score:
                                      CacheHelper.getData(key: 'sports') ?? 0,
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ),

                      ],
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _getAdWidget(),
                    ],
                  ),
                ],
              );
            }),
      ),
    );
  }
}
