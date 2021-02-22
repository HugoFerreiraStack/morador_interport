import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:interport_app/app/modules/eventos/meus_eventos_page/meus_eventos_page.dart';
import 'package:interport_app/app/shared/model/Eventos.dart';
import 'package:intl/intl.dart';
import 'eventos_controller.dart';

class EventosPage extends StatefulWidget {
  final String title;
  const EventosPage({Key key, this.title = "Eventos"}) : super(key: key);

  @override
  _EventosPageState createState() => _EventosPageState();
}

class _EventosPageState extends ModularState<EventosPage, EventosController> {
  //use 'controller' variable to access controller
  TextEditingController _controllerMoradorResponsavel = TextEditingController();
  TextEditingController _controllerNomeEvento = TextEditingController();
  TextEditingController _controllerEspaco = TextEditingController();
  TextEditingController _controllerDescricao = TextEditingController();
  DateTime selectedDate = DateTime.now();
  DateFormat formatter = DateFormat('dd/MM/yyyy');
  String moradorResponsavel;
  String nomeEvento;

  String descricao;
  String hintData = "Data do Evento";
  String hinthoraInicial = "Inicio";
  String hinthoraFinal = "Termino";
  String _idCondominio;
  String _idMorador;
  TimeOfDay horaInicial;
  TimeOfDay horaFinal;
  String _espacoSelecionado = "";
  String _titleAcademia = "Academia";
  String _titleChurrasqueira = "Churrasqueira";
  String _titlePiscina = "Piscina";
  String _titleQuadraDeTenis = "Quadra de Tenis";
  String _titlefutsal = "Quadra de Futsal";
  String _titleSaladeJogos = "Sala de Jogos";
  String _titleSalaoDeFestas = "Salão de Festas";
  String status = "";
  bool _academia = false;
  bool _isAcademia = false;
  bool _churrasqueira = false;
  bool _isChurrasqueira = false;
  bool _piscina = false;
  bool _isPiscina = false;
  bool _quadraDeTenis = false;
  bool _isQuadraDeTenis = false;
  bool _quadraFutsal = false;
  bool _isQuadraFutsal = false;
  bool _salaDeJogos = false;
  bool _isSalaDeJogos = false;
  bool _salaoDeFestas = false;
  bool _isSalaoDeFestas = false;
  Evento _evento;
  String condominioUsuario;

  _verificarUsuarioLogado() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User user = await auth.currentUser;

    FirebaseFirestore db = FirebaseFirestore.instance;
    DocumentSnapshot snapshot =
        await db.collection("Usuarios").doc(user.uid).get();
    final json = snapshot.data();
    String condominio = json["condominio"];
    String morador = json["nome"];
    String id = json["idCondominio"];
    String idMorador = user.uid;

    setState(() {
      condominioUsuario = condominio;
      moradorResponsavel = morador;
      _idCondominio = id;
      _idMorador = idMorador;
    });
  }

  _getEspacosDisponiveis() async {
    await _verificarUsuarioLogado();
    FirebaseFirestore db = FirebaseFirestore.instance;
    DocumentSnapshot snapshot =
        await db.collection("Condominios").doc(_idCondominio).get();
    bool academia = snapshot.get("academia");
    bool churrasqueira = snapshot.get("churrasqueira");
    bool piscina = snapshot.get("piscina");
    bool quadraDeTenis = snapshot.get("quadraDeTenis");
    bool quadraFutsal = snapshot.get("quadraFutsal");
    bool salaDeJogos = snapshot.get("salaDeJogos");
    bool salaoDeFestas = snapshot.get("salaoDeFestas");
    setState(() {
      _academia = academia;
      _churrasqueira = churrasqueira;
      _piscina = piscina;
      _quadraDeTenis = quadraDeTenis;
      _quadraFutsal = quadraFutsal;
      _salaDeJogos = salaDeJogos;
      _salaoDeFestas = salaoDeFestas;
    });
  }

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2025),
        locale: Locale("pt"));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        _evento.data = selectedDate;

        hintData = formatter.format(selectedDate).toString();
      });
  }

  _selectHourInitial(BuildContext context) async {
    TimeOfDay t =
        await showTimePicker(context: context, initialTime: horaInicial);
    if (t != null) {
      setState(() {
        horaInicial = t;
        hinthoraInicial = horaInicial.format(context).toString();
        _evento.horaInicial = horaInicial.toString();
      });
    }
  }

  _selectHourFinal(BuildContext context) async {
    TimeOfDay t =
        await showTimePicker(context: context, initialTime: horaInicial);
    if (t != null) {
      setState(() {
        horaFinal = t;
        hinthoraFinal = horaFinal.format(context).toString();
        _evento.horaFinal = horaFinal.toString();
      });
    }
  }

  _cadastrarEvento() async {
    Evento evento = Evento();
    evento.id = _evento.id;
    evento.moradorResponsavel = moradorResponsavel;
    evento.nomeEvento = nomeEvento;
    evento.espaco = _espacoSelecionado;
    evento.descricao = descricao;
    evento.data = _evento.data;
    evento.horaInicial = hinthoraInicial;
    evento.horaFinal = hinthoraFinal;
    evento.condominio = condominioUsuario;
    evento.idMorador = _idMorador;
    evento.status = false;
    FirebaseFirestore db = FirebaseFirestore.instance;

    db.collection("Eventos").doc(_evento.id).set(evento.toMap());
    _controllerMoradorResponsavel.clear();
    _controllerDescricao.clear();
    _controllerNomeEvento.clear();
    _controllerDescricao.clear();
  }

  @override
  void initState() {
    _verificarUsuarioLogado();
    horaInicial = TimeOfDay.now();
    horaFinal = TimeOfDay.now();
    _evento = Evento.gerarID();
    _getEspacosDisponiveis();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          "Novo Evento",
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Modular.to.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 30,
            ),
            Row(
              children: [
                Text(
                  "Responsável pelo evento",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                )
              ],
            ),
            SizedBox(
              height: 5,
            ),
            TextFormField(
              onChanged: (nome) {
                moradorResponsavel = nome;
              },
              validator: (valor) {
                if (valor.isEmpty) {
                  return "Este campo é obrigatorio";
                }
                return null;
              },
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  hintText: "Responsavel pelo evento",
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
                  "Titulo do Evento",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            TextFormField(
              onChanged: (name) {
                nomeEvento = name;
              },
              validator: (valor) {
                if (valor.isEmpty) {
                  return "Este campo é obrigatorio";
                }
                return null;
              },
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  hintText: "Titulo do Evento",
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
                  "Data do Evento",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            TextFormField(
              readOnly: true,
              onTap: () {
                _selectDate(context);
              },
              decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.calendar_today,
                    color: Color(0xFF1E1C3F),
                  ),
                  hintText: hintData,
                  //hintText: "${selectedDate.toLocal()}".split(' ')[0],
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
                  "Hora do Evento",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: TextField(
                    onTap: () {
                      _selectHourInitial(context);
                    },
                    readOnly: true,
                    decoration: InputDecoration(
                        prefixIcon: Icon(
                          FontAwesomeIcons.clock,
                          color: Color(0xFF1E1C3F),
                        ),
                        hintText: hinthoraInicial,
                        //hintText: "${selectedDate.toLocal()}".split(' ')[0],
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6))),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Flexible(
                  child: TextField(
                    onTap: () {
                      _selectHourFinal(context);
                    },
                    readOnly: true,
                    decoration: InputDecoration(
                        prefixIcon: Icon(
                          FontAwesomeIcons.clock,
                          color: Color(0xFF1E1C3F),
                        ),
                        hintText: hinthoraFinal,
                        //hintText: "${selectedDate.toLocal()}".split(' ')[0],
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6))),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              minLines: 1,
              maxLines: 5,
              onChanged: (desc) {
                descricao = desc;
              },
              validator: (valor) {
                if (valor.isEmpty) {
                  return "Este campo é obrigatorio";
                }
                return null;
              },
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.description,
                    color: Color(0xFF1E1C3F),
                  ),
                  hintText: "Descrição do Evento",
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
                  "Local do Evento",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
            if (_academia == true) ...{
              CheckboxListTile(
                title: Text(_titleAcademia),
                value: _isAcademia,
                onChanged: (newValue) {
                  setState(() {
                    _isAcademia = newValue;
                    _espacoSelecionado = _titleAcademia;
                  });
                },
                controlAffinity:
                    ListTileControlAffinity.leading, //  <-- leading Checkbox
              ),
            },
            if (_churrasqueira == true) ...{
              CheckboxListTile(
                title: Text(_titleChurrasqueira),
                value: _isChurrasqueira,
                onChanged: (newValue) {
                  setState(() {
                    _isChurrasqueira = newValue;
                    _espacoSelecionado = _titleChurrasqueira;
                  });
                },
                controlAffinity:
                    ListTileControlAffinity.leading, //  <-- leading Checkbox
              ),
            },
            if (_piscina == true) ...{
              CheckboxListTile(
                title: Text(_titlePiscina),
                value: _isPiscina,
                onChanged: (newValue) {
                  setState(() {
                    _isPiscina = newValue;
                    _espacoSelecionado = _titlePiscina;
                  });
                },
                controlAffinity:
                    ListTileControlAffinity.leading, //  <-- leading Checkbox
              ),
            },
            if (_quadraDeTenis == true) ...{
              CheckboxListTile(
                title: Text(_titleQuadraDeTenis),
                value: _isQuadraDeTenis,
                onChanged: (newValue) {
                  setState(() {
                    _isQuadraDeTenis = newValue;
                    _espacoSelecionado = _titleQuadraDeTenis;
                  });
                },
                controlAffinity:
                    ListTileControlAffinity.leading, //  <-- leading Checkbox
              ),
            },
            if (_quadraFutsal == true) ...{
              CheckboxListTile(
                title: Text(_titlefutsal),
                value: _isQuadraFutsal,
                onChanged: (newValue) {
                  setState(() {
                    _isQuadraFutsal = newValue;
                    _espacoSelecionado = _titlefutsal;
                  });
                },
                controlAffinity:
                    ListTileControlAffinity.leading, //  <-- leading Checkbox
              ),
            },
            if (_salaoDeFestas == true) ...{
              CheckboxListTile(
                title: Text(_titleSalaoDeFestas),
                value: _isSalaoDeFestas,
                onChanged: (newValue) {
                  setState(() {
                    _isSalaoDeFestas = newValue;
                    _espacoSelecionado = _titleSalaoDeFestas;
                  });
                },
                controlAffinity:
                    ListTileControlAffinity.leading, //  <-- leading Checkbox
              ),
            },
            if (_salaDeJogos == true) ...{
              CheckboxListTile(
                title: Text("Sala de Jogos"),
                value: _isSalaDeJogos,
                onChanged: (newValue) {
                  setState(() {
                    _isSalaDeJogos = newValue;
                    _espacoSelecionado = _titleSaladeJogos;
                  });
                },
                controlAffinity:
                    ListTileControlAffinity.leading, //  <-- leading Checkbox
              ),
            },
            SizedBox(
              height: 20,
            ),
            RaisedButton(
                child: Text(
                  "CADASTRAR",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                color: Color(0xFF1E1C3F),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                padding:
                    EdgeInsets.only(left: 80, right: 80, top: 16, bottom: 16),
                onPressed: () {
                  _cadastrarEvento();
                }),
            _verEventosButton(),
          ],
        ),
      ),
    );
  }

  Widget _verEventosButton() {
    return FlatButton(
      onPressed: () {
        Modular.to.push(MaterialPageRoute(
          builder: (context) => MeusEventosPage(),
        ));
      },
      child: Text('Ver meus eventos'),
    );
  }
}
