import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

void showLoadingDialog(BuildContext context) {
  showDialog(context: context, child: LoadingDialog());
}

void closeLoadingDialog(BuildContext context) {
  Modular.to.pop();
}

class LoadingDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.7,
          height: 140,
          child: Material(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    "Aguarde....",
                    style: Theme.of(context).textTheme.bodyText2,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
