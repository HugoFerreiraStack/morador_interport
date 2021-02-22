import 'package:flutter/material.dart';

import '../../../shared/constants/termos_de_uso.dart';

class TermosUsoBottomSheet extends StatelessWidget {
  String get termos => TERMOS_DE_USO;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            'Termos de Uso',
            style: TextStyle(
              color: Colors.black,
              fontSize: 21,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          Text(termos),
        ],
      ),
    );
  }
}
