import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:khamin/local/cache_helper.dart';
import 'package:khamin/widgets/answer_tile.dart';
import 'package:khamin/widgets/close_button.dart';
import 'package:khamin/widgets/constant.dart';
import 'package:quickalert/quickalert.dart';

import '../controllers/quiz_controller.dart';
import '../models/questionModel.dart';
import 'result_screen.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({
    Key? key,
    required this.questions,
    required this.nameIndex,
    required this.score,
  }) : super(key: key);
  final List<questionModel> questions;
  final String nameIndex;
  final int score;

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {

  int _score = 0;
  int _currentIndex = 0;
  String _selectedAnswer = '';
  int enableAds=0;

  BannerAd? _anchoredAdaptiveAd;
  bool _isLoaded = false;
  late Orientation _currentOrientation;
  InterstitialAd? interstitialAd;

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
  void interstitial(){

    InterstitialAd.load(
      adUnitId: interstitialId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          interstitialAd = ad;
          ad.show();
          interstitialAd?.fullScreenContentCallback =
              FullScreenContentCallback(
                  onAdDismissedFullScreenContent: (ad) {
                    interstitialAd?.dispose();
                    ad.dispose();
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (_) => const Demo(),
                    //   ),
                    // );
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
  void initState() {
      _score = widget.score;
   if (_score == lengthQuestionsArt) {
      if(_score ==1) {
        _score = _score - 1;
      }else{
        _score = _score ;
      }
   }
    _currentIndex =_score;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = widget.questions[_currentIndex];
    return Scaffold(
      backgroundColor: KprimaryScafoldColor,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.04,
                    bottom: 10,
                    right: 16,
                    left: 16
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CustomCloseButton(),
                        Text(
                          'السؤال : $_score',
                          style: TextStyle(
                            color: KprimaryColor,
                            fontSize: MediaQuery.of(context).size.width * 0.09,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: double.maxFinite,
                      child: Text(
                        currentQuestion.question,
                        textAlign: TextAlign.end,
                        style: TextStyle(
                            color: KprimarySupTextColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          boxShadow: [
                            BoxShadow(
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: const Offset(0, 3),
                              color: Colors.black.withOpacity(0.3),
                            ),
                          ],
                          border: Border.all(color: KprimaryScafoldColor)),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.4,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                          currentQuestion.image,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 280,
                      child: Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: currentQuestion.answers.length,
                              itemBuilder: (context, index) {
                                final answer = currentQuestion.answers[index];
                                return AnswerTile(
                                  isSelected: answer == _selectedAnswer,
                                  answer: answer,
                                  correctAnswer: currentQuestion.correctAnswer,
                                  onTap: () {
                                    setState(() {
                                      _selectedAnswer = answer;
                                    });
                                    if (answer == currentQuestion.correctAnswer) {
                                      Future.delayed(const Duration(milliseconds: 200), () {
                                        if (_score != lengthQuestionsArt!-1) {
                                          _score++;
                                          setState(() {
                                            _currentIndex++;
                                            _selectedAnswer = '';
                                          });
                                          if(_score == lengthQuestionsArt!-1){
                                            Get.to(ResultScreen(score: _score, nameIndex: widget.nameIndex,));
                                          }else{
                                            CacheHelper.saveData(key: widget.nameIndex,value: _score);
                                          }
                                        }
                                      });
                                      if(enableAds==4){
                                        interstitial();
                                        enableAds=0;
                                      }
                                      enableAds++;
                                    }else if(answer != currentQuestion.correctAnswer){
                                      if(enableAds==3){
                                        interstitial();
                                        enableAds=0;
                                      }
                                      enableAds++;
                                      QuickAlert.show(
                                        context: context,
                                        type: QuickAlertType.error,
                                        title: 'خطأ',
                                        text: 'لقد خطأت في الاجابة حاول مرة اخرى',
                                      );
                                      Future.delayed(const Duration(milliseconds: 200), () {
                                        setState(() {
                                          _currentIndex;
                                          _selectedAnswer = '';
                                        });
                                      });
                                    }
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 50,),
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
      ),
    );
  }
}
