import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String?> cadastrarUser({
    required String nome,
    required String senha,
    required String email,
  }) async {
    try {
      UserCredential usuario =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: senha,
      );
      await usuario.user!.updateDisplayName(nome);

      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == "email-already-in-use") {
        return "E-mail já cadastrado";
      }

      return "Ocorreu um erro durante sua solicitação!";
    }
  }

  Future<String?> logarUser({
    required String senha,
    required String email,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: senha,
      );

      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<void> logoutUser() async {
    return _firebaseAuth.signOut();
  }
}
