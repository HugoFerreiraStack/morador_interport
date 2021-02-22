import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../model/Usuario.dart';

class UserApi {
  static UserApi get to => Modular.get<UserApi>();

  FirebaseAuth get _auth => FirebaseAuth.instance;
  FirebaseFirestore get _db => FirebaseFirestore.instance;

  Future<Usuario> getCurrentUser() async {
    User user = _auth.currentUser;
    if (user == null) return null;

    return _db
        .collection("Usuarios")
        .doc(user.uid)
        .get()
        .then((value) => Usuario.fromDocumentSnapshot(value));
  }

  Future<void> logout() {
    return _auth.signOut();
  }

  Future<LoginResponse> login(String email, String senha) {
    return _auth.signInWithEmailAndPassword(email: email, password: senha).then(
      (value) async {
        Usuario usuario = await getCurrentUser();
        return LoginResponse(usuario, value.additionalUserInfo.isNewUser);
      },
    );
  }
}

class LoginResponse {
  Usuario usuario;
  bool isNewUser;

  LoginResponse(this.usuario, this.isNewUser);
}
