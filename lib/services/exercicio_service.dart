import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:gymapp/models/exercicio_model.dart';

class ExercicioService {
  String userId;
  ExercicioService() : userId = FirebaseAuth.instance.currentUser!.uid;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addExercicio(ExercicioModel exercicioModel) async {
    await _firestore
        .collection(userId)
        .doc(exercicioModel.id)
        .set(exercicioModel.toMap());
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamExercicios(
      bool isDrecescente) {
    return _firestore
        .collection(userId)
        .orderBy("treino", descending: isDrecescente)
        .snapshots();
  }

  Future<void> deleteExercicio({required ExercicioModel exercicioModel}) async {
    await removeImage(exercicioModel);

    return _firestore.collection(userId).doc(exercicioModel.id).delete();
  }

  Future<void> removeImage(ExercicioModel exercicioModel) async {
    if (exercicioModel.urlImagem != null) {
      await FirebaseStorage.instance.ref(exercicioModel.urlImagem).delete();
    }

    exercicioModel.urlImagem = null;
    addExercicio(exercicioModel);
  }
}
