import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gymapp/models/sentimento_model.dart';

class SentimentoService {
  String userId;
  SentimentoService() : userId = FirebaseAuth.instance.currentUser!.uid;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static const String key = "sentimentos";

  Future<void> addSentimento({
    required String idExercicio,
    required SentimentoModel sentimentoModel,
  }) async {
    return await _firestore
        .collection(userId)
        .doc(idExercicio)
        .collection(key)
        .doc(sentimentoModel.id)
        .set(sentimentoModel.toMap());
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamSentimentos(
      {required String idExercicio}) {
    return _firestore
        .collection(userId)
        .doc(idExercicio)
        .collection(key)
        .orderBy("data", descending: true)
        .snapshots();
  }

  Future<void> deleteSentimento(
      {required String idExercicio, required String idsentimento}) async {
    return _firestore
        .collection(userId)
        .doc(idExercicio)
        .collection(key)
        .doc(idsentimento)
        .delete();
  }
}
