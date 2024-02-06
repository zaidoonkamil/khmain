import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:khamin/models/questionModel.dart';
import 'package:khamin/view/home_screen.dart';

int? lengthQuestionsArt;

class NewQuizController extends GetxController {

  FirebaseFirestore fireStore = FirebaseFirestore.instance;

  @override
  void onInit() {
    quizQuestion();
    lengthQuestionsArt=questionsSports.length;
    super.onInit();
  }

  List<questionModel> questionsSports = [];

  quizQuestion() {

    getAllQuestionsSports().then((value) {
      questionsSports = value;
      lengthQuestionsArt=questionsSports.length;
      update();
    });

  }

  static Future<List<questionModel>> getAllQuestionsSports() async {
    final questionsRef = FirebaseFirestore.instance.collection('sports');
    final questionDoc = await questionsRef.get();
    return questionDoc.docs.map((e) => questionModel.fromQueryDocumentSnapshot(e)).toList();
  }
  static Future<List<questionModel>> getAllQuestionsFamous() async {
    final questionsRef = FirebaseFirestore.instance.collection('famous');
    final questionDoc = await questionsRef.get();

    return questionDoc.docs
        .map((e) => questionModel.fromQueryDocumentSnapshot(e))
        .toList();
  }
  static Future<List<questionModel>> getAllQuestionsCulture() async {
    final questionsRef = FirebaseFirestore.instance.collection('culture');
    final questionDoc = await questionsRef.get();

    return questionDoc.docs
        .map((e) => questionModel.fromQueryDocumentSnapshot(e))
        .toList();
  }
  static Future<List<questionModel>> getAllQuestionsGeography() async {
    final questionsRef = FirebaseFirestore.instance.collection('geography');
    final questionDoc = await questionsRef.get();
    return questionDoc.docs
        .map((e) => questionModel.fromQueryDocumentSnapshot(e)).toList();
  }

  void startAgain() {
    Get.offAll(const HomeScreen());
  }


}
