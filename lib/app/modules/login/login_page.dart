import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../shared/repositories/user_api.dart';
import '../../shared/utils/loading_dialog.dart';
import '../../shared/utils/toasts.dart';
import 'login_controller.dart';
import 'widgets/termos_uso_bottom_sheet.dart';

class LoginPage extends StatefulWidget {
  final String title;
  const LoginPage({Key key, this.title = "Login"}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends ModularState<LoginPage, LoginController> {
  final formKey = GlobalKey<FormState>();

  String email, senha;
  bool showPassword = false;
  bool aceitouTermos = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      verificarUsuarioLogado();
    });
    super.initState();
  }

  Future<void> verificarUsuarioLogado() async {
    showLoadingDialog(context);
    return UserApi.to.getCurrentUser().then((value) {
      closeLoadingDialog(context);
      if (value != null) redirecionarUsuario(value.tipoUsuario);
    }).catchError((err) {
      closeLoadingDialog(context);
      print('Erro: $err');
    });
  }

  Future<void> login(BuildContext context) async {
    if (!formKey.currentState.validate())
      return Toasts.showError(context, 'Verifique os campos e tente novamente');

    if (!aceitouTermos)
      return Toasts.showError(context, 'Para continuar aceite os termos');

    formKey.currentState.save();

    showLoadingDialog(context);
    return UserApi.to.login(email, senha).then((value) {
      closeLoadingDialog(context);
      redirecionarUsuario(value.usuario.tipoUsuario);
    }).catchError((err) {
      closeLoadingDialog(context);
      print('Erro: $err');
      if (err is FirebaseAuthException) {
        switch (err.code) {
          case 'invalid-email':
            return Toasts.showError(context, 'Email inválido');
          case 'user-not-found':
            return Toasts.showError(context, 'Usuário nao cadastrado');
          case 'wrong-password':
            return Toasts.showError(context, 'Senha inválida');
          case 'user-disabled':
            return Toasts.showError(context, 'Seu usuario foi desativado');
          default:
            return Toasts.showError(context, 'Erro inesperado');
        }
      }

      return Toasts.showError(context, 'Erro inesperado');
    });
  }

  void showTermos(BuildContext context) {
    showBottomSheet(context: context, builder: (_) => TermosUsoBottomSheet());
  }

  void redirecionarUsuario(String tipoUsuario) {
    if (tipoUsuario == "Morador") {
      Modular.to.pushReplacementNamed("/start");
    } else if (tipoUsuario == "Admin") {
      Modular.to.pushReplacementNamed("/admin");
    } else if (tipoUsuario == "Sindico") {
      Modular.to.pushReplacementNamed("start");
    }
  }

  String senhaValidator(String value) {
    if (value.isEmpty) return 'Senha é obrigatória';
    if (value.length < 6) return 'Senha deve ter no minimo 6 caracteres';

    return null;
  }

  String emailValidator(String value) {
    if (value.isEmpty) return 'Email é obrigatório';

    String regex =
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    if (!RegExp(regex).hasMatch(value)) return 'Email invalido';

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF1E1C3F),
        title: Text(widget.title),
      ),
      body: Builder(
        builder: (context) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "ENTRAR COM CONTA",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                _form(),
                SizedBox(height: 20),
                _termosUsoCheckbox(context),
                SizedBox(height: 20),
                RaisedButton(
                  color: Color(0xFF1E1C3F),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  padding:
                      EdgeInsets.only(left: 80, right: 80, top: 16, bottom: 16),
                  onPressed: () => login(context),
                  child: Text(
                    "CONTINUAR",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    FlatButton(
                      onPressed: () {},
                      child: Text(
                        "Esqueceu a Senha?",
                        style: TextStyle(color: Colors.cyan, fontSize: 15),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _termosUsoCheckbox(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: aceitouTermos,
          onChanged: (_) => setState(() => aceitouTermos = _),
        ),
        SizedBox(width: 5),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: TextStyle(
                color: Colors.black,
              ),
              children: [
                TextSpan(text: 'Ao continuar declaro que li e aceito os '),
                TextSpan(
                  text: 'termos de uso',
                  style: TextStyle(decoration: TextDecoration.underline),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => showTermos(context),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _form() {
    return Form(
      key: formKey,
      child: Column(
        children: [
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onSaved: (newValue) => email = newValue,
            validator: emailValidator,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.email,
                color: Colors.black,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              labelText: 'E-mail',
            ),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onSaved: (newValue) => senha = newValue,
            validator: senhaValidator,
            keyboardType: TextInputType.visiblePassword,
            obscureText: !showPassword,
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.black,
              ),
              suffixIcon: GestureDetector(
                onTap: () => setState(() => showPassword = !showPassword),
                child: Icon(
                  showPassword ? Icons.visibility : Icons.visibility_off,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              labelText: 'Senha',
            ),
          ),
        ],
      ),
    );
  }
}
