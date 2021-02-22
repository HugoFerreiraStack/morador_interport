import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:interport_app/app/shared/model/Eventos.dart';

import '../model/ocorrencia.dart';

class EventosApi {
  static EventosApi get to => Modular.get<EventosApi>();

  FirebaseFirestore get _db => FirebaseFirestore.instance;

  Stream<List<Evento>> eventosSnapshot(String userId) {
    return _db
        .collection('Eventos')
        .where('idMorador', isEqualTo: userId)
        .orderBy('data', descending: true)
        .snapshots()
        .map((event) => event.docs.map((e) {
              final evento = Evento.fromDocumentSnapshot(e);
              return evento;
            }).toList());
  }

  Stream<List<Convidado>> convidadosSnapshot(String eventoId) {
    return _db
        .collection('Eventos')
        .doc(eventoId)
        .collection('convidados')
        .orderBy('nome')
        .snapshots()
        .map((event) => event.docs.map((e) {
              final convidado = Convidado.fromJson(e.data());
              convidado.id = e.id;
              return convidado;
            }).toList());
  }

  Future<void> addConvidados(String eventoId, Convidado convidado) {
    return _db
        .collection('Eventos')
        .doc(eventoId)
        .collection('convidados')
        .add(convidado.toJson());
  }

  Future<void> removerConvidado(String eventoId, Convidado convidado) {
    return _db
        .collection('Eventos')
        .doc(eventoId)
        .collection('convidados')
        .doc(convidado.id)
        .delete();
  }
}
