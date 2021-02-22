import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:interport_app/app/shared/utils/loading_dialog.dart';
import 'package:interport_app/app/shared/utils/permission_dialog.dart';

import '../../../shared/model/Eventos.dart';
import '../../../shared/repositories/eventos_api.dart';
import 'widgets/adicionar_convidado_bottom_sheet.dart';

class ConvidadosPage extends StatefulWidget {
  final Evento evento;

  ConvidadosPage(this.evento);

  @override
  _ConvidadosPageState createState() => _ConvidadosPageState();
}

class _ConvidadosPageState extends State<ConvidadosPage> {
  void adicionarConvidado(BuildContext context) {
    Scaffold.of(context).showBottomSheet(
        (context) => AdicionarConvidadoBottomSheet(widget.evento.id));
  }

  void deleteConvidado(Convidado convidado) async {
    bool confirmado = await getUserPermission(
      context,
      'Você está preste a remover um convidado, deseja continuar?',
    );

    if (confirmado) {
      await EventosApi.to.removerConvidado(widget.evento.id, convidado);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Builder(
        builder: (context) => FloatingActionButton(
          onPressed: () => adicionarConvidado(context),
          child: Icon(Icons.add),
        ),
      ),
      appBar: AppBar(
        leading: BackButton(
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          widget.evento.nomeEvento,
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: StreamBuilder<List<Convidado>>(
        stream: EventosApi.to.convidadosSnapshot(widget.evento.id),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print('snapshot error: ${snapshot.error}');
            return Center(
              child: Text('Ocorreu um erro inesperado'),
            );
          }

          if (snapshot.hasData) return convidadosList(snapshot.data);

          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Widget convidadosList(List<Convidado> convidados) {
    if (convidados.isEmpty)
      return Center(
        child: Text('Nenhum convidado registrado'),
      );

    return ListView.builder(
      itemCount: convidados.length,
      itemBuilder: (context, index) {
        final convidado = convidados[index];
        return ListTile(
          onLongPress: () => deleteConvidado(convidado),
          title: Text(convidado.nome),
          subtitle: Text(convidado.cpf),
        );
      },
    );
  }
}
