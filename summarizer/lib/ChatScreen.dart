import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:summarizer/Logic.dart';

class ChatScreen extends StatefulWidget {
  @override
  ChatScreenState createState() => ChatScreenState();
}

TextEditingController _txt = TextEditingController();
List conversation = [
  {'who': 'me', 'res': 'akjb askhfbskdh  sldhjfb'},
  {'who': 'other', 'res': 'akjb askhfbskdh  sldhjfb'},
  {'who': 'me', 'res': 'akjb askhfbskdh  sldhjfb'},
  {'who': 'me', 'res': 'akjb askhfbskdh  sldhjfb'},
  {'who': 'other', 'res': 'akjb askhfbskdh  sldhjfb'},
];

class ChatScreenState extends State<ChatScreen> {
  final Uri uri = Uri.parse('http://localhost:3000/question');

  @override
  Widget build(BuildContext context) {
    double hh = MediaQuery.of(context).size.height;
    double ww = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 12, 114, 155),
        title: Text(
          'Ask a question',
          style: GoogleFonts.ubuntu(fontSize: 16),
        ),
        centerTitle: true,
      ),
      body: Container(
        height: hh,
        width: ww,
        decoration: BoxDecoration(color: Color.fromARGB(255, 104, 188, 245)),
        child: chatSection(),
      ),
      bottomSheet: Container(
        width: ww,
        height: 100,
        decoration: BoxDecoration(color: Color.fromARGB(255, 104, 188, 245)),
        child: Center(
            child: Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Row(children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(

                      // width: 100,
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      decoration: InputDecoration(fillColor: Colors.blue[700]),
                      controller: _txt,
                    ),
                  )),
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      conversation.add({
                        'who': 'me',
                        'res': _txt.value.text,
                      });
                    });
                  },
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(0),
                      backgroundColor: Colors.black),
                  child: Icon(
                    Icons.send,
                    color: Colors.white,
                    size: 20,
                  ))
            ]),
          ),
        )),
      ),
    );
  }

  chatSection() {
    return Container(
        height: 200,
        padding: const EdgeInsets.all(20),
        width: MediaQuery.of(context).size.width,
        child: ListView.builder(
            itemCount: conversation.length,
            itemBuilder: (context, index) {
              return Align(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    // constraints: BoxConstraints(maxWidth: 200),
                    alignment: (conversation[index]['who'] == 'me')
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                        padding: const EdgeInsets.all(15),
                        // width: 300,
                        decoration: BoxDecoration(
                          // border: Border.all(),
                          color: (conversation[index]['who'] == 'me')
                              ? Colors.white
                              : Color.fromARGB(255, 12, 114, 155),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '' + conversation[index]['res'],
                          style: GoogleFonts.ubuntu(),
                          textAlign: (conversation[index]['who'] == 'me')
                              ? TextAlign.right
                              : TextAlign.left,
                        )),
                  ),
                ),
              );
            }));
  }
}
