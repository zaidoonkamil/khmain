import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:khamin/controllers/quiz_controller.dart';
import 'package:khamin/local/cache_helper.dart';
import 'package:khamin/widgets/constant.dart';
import 'package:khamin/widgets/custom_button.dart';

import 'home_screen.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({Key? key, required this.score, required this.nameIndex}) : super(key: key);

  final int score;
  final String nameIndex;

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  BannerAd? _anchoredAdaptiveAd;

  bool _isLoaded = false;

  late Orientation _currentOrientation;

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
        if (_currentOrientation == orientation && _anchoredAdaptiveAd != null && _isLoaded) {
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
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: KprimaryScafoldColor,
        body: SafeArea(
          child: Stack(
            children: [
              Center(
                child: GetBuilder<NewQuizController>(
                  init: Get.put(NewQuizController()),
                  builder: (controller) => Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      Text(
                        'مستواك هو ',
                        style: Theme.of(context).textTheme.headline4!.copyWith(
                              color: KprimarySupTextColor,
                            ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Text(
                        '${widget.score}',
                        style: Theme.of(context).textTheme.headline3!.copyWith(
                              color: KprimarySupTextColor,
                            ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      CustomButton(
                          onPressed: (){
                            Get.offAll(const HomeScreen());
                            CacheHelper.removeData(key:  widget.nameIndex);
                          },
                          text: 'البدء مجددا'),
                    ],
                  ),
                ),
              ),
               Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _getAdWidget(),
                ],
              ),
            ],
          ),
        ));
  }
}
