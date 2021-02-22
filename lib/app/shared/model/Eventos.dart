import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';

class Evento {
  String id;
  String idMorador;
  String moradorResponsavel;
  String nomeEvento;
  String condominio;
  String espaco;
  String descricao;
  DateTime data;
  String horaInicial;
  String horaFinal;
  bool status;

  Evento();

  Evento.fromDocumentSnapshot(DocumentSnapshot documentSnapshot) {
    DateFormat format = DateFormat('dd/MM/yyy');
    Map<String, dynamic> json = documentSnapshot.data();

    this.id = documentSnapshot.id;
    this.idMorador = json['idMorador'];
    this.moradorResponsavel = json['moradorResponsavel'];
    this.nomeEvento = json['nomeEvento'];
    this.condominio = json['condominio'];
    this.espaco = json['espaco'];
    this.descricao = json['descricao'];
    this.data = format.parse(json['data']);
    this.horaInicial = json['horaInicial'];
    this.horaFinal = json['horaFinal'];
    this.status = json['status'];
  }

  Evento.gerarID() {
    FirebaseFirestore db = FirebaseFirestore.instance;
    CollectionReference eventos = db.collection("Eventos");
    this.id = eventos.doc().id;
  }

  Map<String, dynamic> toMap() {
    DateFormat format = DateFormat('dd/MM/yyy');
    Map<String, dynamic> map = {
      "id": this.id,
      "idMorador": this.idMorador,
      "moradorResponsavel": this.moradorResponsavel,
      "nomeEvento": this.nomeEvento,
      "condominio": this.condominio,
      "espaco": this.espaco,
      "descricao": this.descricao,
      "data": format.format(this.data),
      "horaInicial": this.horaInicial,
      "horaFinal": this.horaFinal,
      "status": this.status,
    };
    return map;
  }
}

class Convidado {
  String nome;
  String cpf;
  String id;

  Convidado({
    @required this.nome,
    @required this.cpf,
  });

  static Convidado fromJson(Map<String, dynamic> json) {
    return Convidado(
      cpf: json['cpf'],
      nome: json['nome'],
    );
  }

  Map<String, dynamic> toJson() => {
        'nome': this.nome,
        'cpf': this.cpf,
      };
}
