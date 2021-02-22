import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../model/ocorrencia.dart';

class OcorrenciasApi {
  static OcorrenciasApi get to => Modular.get<OcorrenciasApi>();

  FirebaseFirestore get _db => FirebaseFirestore.instance;

  Future<void> registrarOcorrencia(Ocorrencia ocorrencia) {
    return _db.collection('Ocorrencias').add(ocorrencia.toJson());
  }

  Stream<List<Ocorrencia>> ocorrenciasSnapshot(String userId) {
    return _db
        .collection('Ocorrencias')
        .snapshots()
        .map((event) => event.docs.map((e) {
              final ocorrencia = Ocorrencia.fromJson(e.data());
              ocorrencia.id = e.id;
              return ocorrencia;
            }));
  }
}
