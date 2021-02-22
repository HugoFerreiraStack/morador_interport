import 'package:flutter/material.dart';

class TextComposer extends StatefulWidget {
  @override
  _TextComposerState createState() => _TextComposerState();
}

class _TextComposerState extends State<TextComposer> {
  bool isComposing = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.photo_camera),
            onPressed: () {},
          ),
          Expanded(
            child: TextField(
              decoration:
                  InputDecoration.collapsed(hintText: "Enviar mensagem"),
              onChanged: (text) {
                setState(() {
                  isComposing = text.isNotEmpty;
                });
              },
              onSubmitted: (text) {},
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: isComposing ? () {} : null,
          )
        ],
      ),
    );
  }
}
