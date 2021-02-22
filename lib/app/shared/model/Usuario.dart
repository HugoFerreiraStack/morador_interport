import 'package:cloud_firestore/cloud_firestore.dart';

class Usuario {
  String id;
  String nome;
  String email;
  String telefone;
  String senha;
  String condominio;
  String apartamento;
  String bloco;
  String tipoUsuario;
  String urlImage;
  bool master;
  DateTime lastMessageTime;

  Usuario();

  Usuario.fromDocumentSnapshot(DocumentSnapshot documentSnapshot) {
    Map<String, dynamic> json = documentSnapshot.data();

    this.id = documentSnapshot.id;
    this.nome = json['nome'];
    this.email = json['email'];
    this.telefone = json['telefone'];
    this.condominio = json['condominio'];
    this.bloco = json['bloco'];
    this.apartamento = json['apartamento'];
    this.tipoUsuario = json['tipoUsuario'];
    this.urlImage = json['urlImage'];
    this.master = json['master'];
    this.lastMessageTime = json['lastMessageTime'];
  }

  Usuario.gerarID() {
    FirebaseFirestore db = FirebaseFirestore.instance;
    CollectionReference condominios = db.collection("Usuarios");
    this.id = condominios.doc().id;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "id": this.id,
      "nome": this.nome,
      "email": this.email,
      "telefone": this.telefone,
      "condominio": this.condominio,
      "bloco": this.bloco,
      "apartamento": this.apartamento,
      "tipoUsuario": this.tipoUsuario,
      "urlImage": this.urlImage,
      "master": this.master,
      "lastMessageTime": this.lastMessageTime,
    };
    return map;
  }
}
