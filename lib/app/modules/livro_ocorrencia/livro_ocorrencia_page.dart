import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:interport_app/app/shared/model/ocorrencia.dart';
import 'livro_ocorrencia_controller.dart';
import 'package:extended_masked_text/extended_masked_text.dart';

class LivroOcorrenciaPage extends StatefulWidget {
  final String title;
  const LivroOcorrenciaPage({Key key, this.title = "LivroOcorrencia"})
      : super(key: key);

  @override
  _LivroOcorrenciaPageState createState() => _LivroOcorrenciaPageState();
}

class _LivroOcorrenciaPageState
    extends ModularState<LivroOcorrenciaPage, LivroOcorrenciaController> {
  //use 'controller' variable to access controller

  TextEditingController _controllerTitle = TextEditingController();
  TextEditingController _controllerDescricao = TextEditingController();
  String _idUsuario;
  String _nomeUsuario;
  String _telefoneUsuario;
  String _condominioNome;
  String _condominioId;
  String _apartamento;
  String _bloco;
  String _descricao;
  String _title;
  Ocorrencia _ocorrencia;

  _verificarUsuarioLogado() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User user = await auth.currentUser;
    FirebaseFirestore db = FirebaseFirestore.instance;
    DocumentSnapshot snapshot =
        await db.collection("Usuarios").doc(user.uid).get();
    String id = snapshot.get("id");
    String nome = snapshot.get("nome");
    String telefone = snapshot.get("telefone");
    String condominio = snapshot.get("condominio");
    String condominioId = snapshot.get("idCondominio");
    String apartamento = snapshot.get("apartamento");
    String bloco = snapshot.get("bloco");

    setState(() {
      _idUsuario = id;
      _nomeUsuario = nome;
      _telefoneUsuario = telefone;
      _condominioNome = condominio;
      _condominioId = condominioId;
      _apartamento = apartamento;
      _bloco = bloco;
    });
  }

  _cadastrarOcorrencia() async {
    Ocorrencia ocorrencia = Ocorrencia(
      id: _ocorrencia.id,
      idUsuario: _idUsuario,
      condominioId: _condominioId,
      apartamento: _apartamento,
      bloco: _bloco,
      condominioNome: _condominioNome,
      data: DateTime.now(),
      descricao: _descricao,
      nomeUsuario: _nomeUsuario,
      telefoneUsuario: _telefoneUsuario,
      title: _title,
    );
    FirebaseFirestore db = FirebaseFirestore.instance;
    db.collection("Ocorrencias").doc(_ocorrencia.id).set(ocorrencia.toJson());
    _controllerTitle.clear();
    _controllerDescricao.clear();
  }

  @override
  void initState() {
    _verificarUsuarioLogado();
    _ocorrencia = Ocorrencia.gerarID();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          "Livro de Ocorrência",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 80,
            ),
            Row(
              children: [
                Text(
                  "Titulo da Ocorrência",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                )
              ],
            ),
            SizedBox(
              height: 5,
            ),
            TextFormField(
              controller: _controllerTitle,
              onChanged: (titulo) {
                _title = titulo;
              },
              validator: (valor) {
                if (valor.isEmpty) {
                  return "Este campo é obrigatorio";
                }
                return null;
              },
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  hintText: "Titulo",
                  contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6))),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Text(
                  "Descricao da Ocorrencia",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            TextFormField(
              controller: _controllerDescricao,
              onChanged: (desc) {
                _descricao = desc;
              },
              validator: (valor) {
                if (valor.isEmpty) {
                  return "Este campo é obrigatorio";
                }
                return null;
              },
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  hintText: "Descrição da ocorrencia",
                  contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6))),
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 20,
            ),
            RaisedButton(
                child: Text(
                  "ENVIAR",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                color: Color(0xFF1E1C3F),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                padding:
                    EdgeInsets.only(left: 80, right: 80, top: 16, bottom: 16),
                onPressed: () {
                  _cadastrarOcorrencia();
                }),
          ],
        ),
      ),
    );
  }
}
