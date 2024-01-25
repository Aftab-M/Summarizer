import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:summarizer/Logic.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ChatScreen extends StatefulWidget {
  final String cont;
  const ChatScreen({required this.cont});
  @override
  ChatScreenState createState() => ChatScreenState();
}

TextEditingController _txt = TextEditingController();
List conversation = [
  {
    'who': 'other',
    'res': 'Hello There ! \nAsk me anything about the provided text...'
  },
];

// String cont = "";

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
                  onPressed: () async {
                    setState(() {
                      conversation.add({
                        'who': 'me',
                        'res': _txt.value.text,
                      });
                      conversation.add({
                        'who': 'other',
                        'res': 'Reading the provided material for answers...'
                      });

                      Timer(Duration(seconds: 2), () {
                        communicate();
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
        padding:
            const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 100),
        width: MediaQuery.of(context).size.width,
        child: ListView.builder(
            itemCount: conversation.length,
            itemBuilder: (context, index) {
              return Align(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    alignment: (conversation[index]['who'] == 'me')
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                        padding: const EdgeInsets.all(15),
                        constraints: BoxConstraints(maxWidth: 400),
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

  // uploadFile(fileName, fileBytes) async {
  //   try {
  //     print('In uploadFile');
  //     Reference storeRef = FirebaseStorage.instance.ref();

  //     Reference pdfRef = storeRef.child('pdfs/$fileName');

  //     // String cont = "";

  //     await pdfRef.putData(fileBytes).then((p0) {
  //       debugPrint('File Uploaded Successfully !!! $p0');
  //       pdfRef.getDownloadURL().then((value) async {
  //         // debugPrint('Value is : $value');
  //         Map<String, dynamic> pdfUrl = {'url': value};

  //         final res = await http.post(Uri.parse('http://localhost:3000/parse'),
  //             headers: {'Content-Type': 'application/json'},
  //             body: jsonEncode(pdfUrl));

  //         print("Got the response : ${res.body}");
  //         setState(() {
  //           cont = res.body;
  //         });
  //       });
  //     });
  //   } catch (e) {
  //     print("Got error ${e.toString()}");
  //   }
  // }

  communicate() async {
    final Map<String, dynamic> data = {
      'ques': _txt.value.text,
      'context': widget.cont,
    };

    // CircularProgressIndicator();
    final response = await http.post(
        Uri.parse('http://localhost:3000/question'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data));

    print("Response is : ${response.body}");
    setState(() {
      conversation.removeLast();
      conversation.add({
        'who': 'other',
        'res': response.body,
      });
    });
  }
}
