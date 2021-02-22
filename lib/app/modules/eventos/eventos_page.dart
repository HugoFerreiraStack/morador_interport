import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:interport_app/app/shared/model/Eventos.dart';
import 'eventos_controller.dart';

class EventosPage extends StatefulWidget {
  final String title;
  const EventosPage({Key key, this.title = "Eventos"}) : super(key: key);

  @override
  _EventosPageState createState() => _EventosPageState();
}

class _EventosPageState extends ModularState<EventosPage, EventosController> {
  //use 'controller' variable to access controller
  final formKey = GlobalKey<FormState>();
  TextEditingController _controllerMoradorResponsavel = TextEditingController();
  TextEditingController _controllerNomeEvento = TextEditingController();
  TextEditingController _controllerEspaco = TextEditingController();
  TextEditingController _controllerDescricao = TextEditingController();
  DateTime selectedDate = DateTime.now();
  String moradorResponsavel;
  String nomeEvento;
  String espaco;
  String descricao;
  String hintData = "Data do Evento";
  String hinthoraInicial = "Hora de Inicio";
  String hinthoraFinal = "Hora de Termino";
  TimeOfDay horaInicial;
  TimeOfDay horaFinal;
  bool status = false;
  Evento _evento;
  String condominioUsuario;
  final _controller = StreamController<QuerySnapshot>.broadcast();

  _verificarUsuarioLogado() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User user = await auth.currentUser;

    FirebaseFirestore db = FirebaseFirestore.instance;
    DocumentSnapshot snapshot =
        await db.collection("Usuarios").doc(user.uid).get();
    String condominio = snapshot.get("condominio");
    String morador = snapshot.get("nome");

    setState(() {
      condominioUsuario = condominio;
      moradorResponsavel = morador;
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
        _evento.data = selectedDate.toString();

        hintData = "${selectedDate.toLocal()}".split(' ')[0];
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
    FirebaseFirestore db = FirebaseFirestore.instance;

    db.collection("Eventos").doc(_evento.id).set(_evento.toMap());
  }

  @override
  void initState() {
    _verificarUsuarioLogado();
    horaInicial = TimeOfDay.now();
    horaFinal = TimeOfDay.now();
    _evento = Evento.gerarID();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 30,
                ),
                TextFormField(
                  onSaved: (nome) {
                    _evento.moradorResponsavel = nome;
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
                        Icons.person,
                        color: Color(0xFF1E1C3F),
                      ),
                      hintText: "Responsavel pelo evento",
                      contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6))),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  onSaved: (nomeEvento) {
                    _evento.nomeEvento = nomeEvento;
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
                        Icons.title,
                        color: Color(0xFF1E1C3F),
                      ),
                      hintText: "Nome do Evento",
                      contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6))),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  onSaved: (dataEvento) {},
                  keyboardType: TextInputType.datetime,
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
                TextButton(
                  onPressed: () => _selectDate(context),
                  child: Text(
                    "Selecione a data do evento",
                    style: TextStyle(fontSize: 15),
                  ),
                ),
                TextField(
                  keyboardType: TextInputType.datetime,
                  decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.calendar_today,
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
                TextButton(
                  onPressed: () => _selectHourInitial(context),
                  child: Text(
                    "Selecione Hora inicial",
                    style: TextStyle(fontSize: 15),
                  ),
                ),
                TextField(
                  keyboardType: TextInputType.datetime,
                  decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.calendar_today,
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
                TextButton(
                  onPressed: () => _selectHourFinal(context),
                  child: Text(
                    "Selecione Hora Final",
                    style: TextStyle(fontSize: 15),
                  ),
                ),
                TextFormField(
                  onSaved: (descricao) {
                    _evento.descricao = descricao;
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
                        Icons.person,
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
                  onPressed: () async {
                    if (formKey.currentState.validate()) {
                      setState(() {
                        _evento.status = status;
                        _evento.condominio = condominioUsuario;
                        _evento.moradorResponsavel =
                            _controllerMoradorResponsavel.text;
                        _evento.nomeEvento = _controllerNomeEvento.text;
                        formKey.currentState.save();
                        _cadastrarEvento();
                        Modular.to.pop();
                      });
                    }
                  },
                ),
                SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
