import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:interport_app/app/shared/model/Eventos.dart';
import 'package:interport_app/app/shared/repositories/eventos_api.dart';
import 'package:interport_app/app/shared/utils/loading_dialog.dart';

class AdicionarConvidadoBottomSheet extends StatefulWidget {
  final String eventoId;

  AdicionarConvidadoBottomSheet(this.eventoId);

  @override
  _AdicionarConvidadoBottomSheetState createState() =>
      _AdicionarConvidadoBottomSheetState();
}

class _AdicionarConvidadoBottomSheetState
    extends State<AdicionarConvidadoBottomSheet> {
  final formKey = GlobalKey<FormState>();
  final cpfController = MaskedTextController(mask: '000.000.000-00');

  String nome, cpf;

  String nomeValidator(String value) {
    if (value.isEmpty) return 'Campo obrigatório';

    return null;
  }

  String cpfValidator(String value) {
    if (value.isEmpty) return 'Campo obrigatório';

    if (value.length < 14) return 'CPF inválido';

    return null;
  }

  void adicionarConvidado() {
    if (!formKey.currentState.validate()) return;
    FocusScope.of(context).unfocus();
    formKey.currentState.save();
    cpf = cpfController.text;

    showLoadingDialog(context);
    Convidado convidado = Convidado(nome: nome, cpf: cpf);
    EventosApi.to.addConvidados(widget.eventoId, convidado).then((value) {
      closeLoadingDialog(context);
      Modular.to.pop();
      print('sucesso');
    }).catchError((err) {
      closeLoadingDialog(context);
      print('error: $err');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Form(
        key: formKey,
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.all(20),
          children: [
            TextFormField(
              onChanged: (value) => nome = value,
              validator: nomeValidator,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: InputDecoration(
                labelText: 'Nome',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: cpfController,
              onChanged: (value) => cpf = value,
              validator: cpfValidator,
              keyboardType: TextInputType.number,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: InputDecoration(
                labelText: 'CPF',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            RaisedButton(
              onPressed: adicionarConvidado,
              child: Text('Adicionar'),
            ),
          ],
        ),
      ),
    );
  }
}
