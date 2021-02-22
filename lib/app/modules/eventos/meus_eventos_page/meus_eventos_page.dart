import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:interport_app/app/modules/eventos/convidados_page/lista_convidados_page.dart';
import 'package:intl/intl.dart';

import '../../../shared/model/Eventos.dart';
import '../../../shared/model/Usuario.dart';
import '../../../shared/repositories/eventos_api.dart';
import '../../../shared/repositories/user_api.dart';

class MeusEventosPage extends StatefulWidget {
  @override
  _MeusEventosPageState createState() => _MeusEventosPageState();
}

class _MeusEventosPageState extends State<MeusEventosPage> {
  Usuario usuario;

  bool loading = true;
  bool hasError = false;

  Future<void> verificarUsuarioLogado() async {
    setState(() {
      loading = true;
      hasError = false;
    });

    return UserApi.to.getCurrentUser().then((value) {
      usuario = value;

      setState(() {
        loading = false;
        hasError = false;
      });
    }).catchError((err) {
      setState(() {
        loading = false;
        hasError = true;
      });

      print('Erro: $err');
    });
  }

  void verConvidados(Evento evento) {
    if (evento.status == false) return;
    Modular.to.push(MaterialPageRoute(
      builder: (context) => ConvidadosPage(evento),
    ));
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      verificarUsuarioLogado();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Colors.black,
        ),
        title: Text(
          'Meus Eventos',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Builder(builder: (context) {
        if (loading) return loadingWidget();
        if (hasError)
          return loadingErrorWidget(
            'Ocorreu um erro ao validar o usuario',
            verificarUsuarioLogado,
          );

        return StreamBuilder<List<Evento>>(
          stream: EventosApi.to.eventosSnapshot(usuario.id),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              print('snapshot error: ${snapshot.error}');
              return Center(
                child: Text('Ocorreu um erro inesperado'),
              );
            }

            if (snapshot.hasData) return eventosList(snapshot.data);

            return Center(
              child: CircularProgressIndicator(),
            );
          },
        );
      }),
    );
  }

  Widget loadingWidget() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget loadingErrorWidget(String message, void Function() reload) {
    return Center(
      child: Column(
        children: [
          Text(message),
          SizedBox(height: 20),
          RaisedButton(
            onPressed: reload,
            child: Text('Recarregar'),
          )
        ],
      ),
    );
  }

  Widget eventosList(List<Evento> eventos) {
    final dateFormat = DateFormat('dd/MM/yyy');

    if (eventos.isEmpty)
      return Center(
        child: Text('Nenhum evento encontrado'),
      );

    return ListView.builder(
      itemCount: eventos.length,
      itemBuilder: (context, index) {
        final evento = eventos[index];
        return ListTile(
          onTap: () => verConvidados(evento),
          title: Row(
            children: [
              Expanded(child: Text(evento.nomeEvento)),
              SizedBox(width: 10),
              Text(
                dateFormat.format(evento.data),
                style: TextStyle(fontSize: 14, color: Colors.grey),
              )
            ],
          ),
          subtitle: Text(evento.descricao),
          leading: evento.status
              ? Icon(
                  Icons.check_circle_outline,
                  color: Colors.green,
                )
              : Icon(Icons.alarm),
        );
      },
    );
  }
}
