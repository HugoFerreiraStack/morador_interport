import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

class Ocorrencia {
  String id;
  String idUsuario;
  String title;
  String nomeUsuario;
  String telefoneUsuario;
  String condominioNome;
  String condominioId;
  String apartamento;
  String bloco;
  DateTime data;
  String descricao;

  Ocorrencia({
    this.id,
    @required this.idUsuario,
    @required this.nomeUsuario,
    @required this.telefoneUsuario,
    @required this.condominioNome,
    @required this.condominioId,
    @required this.apartamento,
    @required this.bloco,
    @required this.data,
    @required this.descricao,
    @required this.title,
  });

  Ocorrencia.gerarID() {
    FirebaseFirestore db = FirebaseFirestore.instance;
    CollectionReference ocorrencias = db.collection("Ocorrencias");
    this.id = ocorrencias.doc().id;
  }

  static Ocorrencia fromJson(Map<String, dynamic> json) {
    return Ocorrencia(
      idUsuario: json['idUsuario'],
      nomeUsuario: json['nomeUsuario'],
      telefoneUsuario: json['telefoneUsuario'],
      condominioNome: json['condominioNome'],
      condominioId: json['condominioId'],
      apartamento: json['apartamento'],
      bloco: json['bloco'],
      data: json['data'].toDate(),
      descricao: json['descricao'],
      title: json['titulo'],
    );
  }

  Map<String, dynamic> toJson() => {
        "idUsuario": this.idUsuario,
        "nomeUsuario": this.nomeUsuario,
        "telefoneUsuario": this.telefoneUsuario,
        "condominioNome": this.condominioNome,
        "condominioId": this.condominioId,
        "apartamento": this.apartamento,
        "bloco": this.bloco,
        "data": Timestamp.fromDate(this.data),
        "descricao": this.descricao,
        "titulo": this.title,
      };
}
