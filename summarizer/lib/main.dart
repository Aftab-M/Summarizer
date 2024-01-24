import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:summarizer/ChatScreen.dart';
import 'package:summarizer/firebase_options.dart';
import 'package:http/http.dart' as http;
import 'package:summarizer/Logic.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // home: const MyHomePage(title: 'Summarizer'),
      home: ChatScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _contextTextController =
      new TextEditingController();
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Provide a PDF'),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () async {
                // var file =
                // await FilePicker.platform.pickFiles(type: FileType.any);
                // Uint8List uploadedFile;
                FilePickerResult? result =
                    await FilePicker.platform.pickFiles();
                if (result != null) {
                  Uint8List? fileBytes = result.files.first.bytes;
                  String fileName = result.files.first.name;
                  debugPrint(" File name : ${fileName} ");
                  uploadFile(fileName, fileBytes);
                }
              },
              child: const Text('Pick a file'),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(20)),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 50, bottom: 50),
              child: Text(" - OR - "),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: 20,
                  bottom: 20,
                  left: (width < 500) ? 20 : 100,
                  right: (width < 500) ? 20 : 100),
              child: TextField(
                controller: _contextTextController,
                maxLines: 10,
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(30),
                    // suffixIcon: IconButton(
                    //     onPressed: () {},
                    //     icon: const Icon(Icons.send),
                    //     alignment: Alignment.bottomRight),
                    // hoverColor: Colors.black,
                    suffix: IconButton(
                        padding: const EdgeInsets.all(20),
                        onPressed: () async {
                          if (_contextTextController.value.text.length > 2) {
                            await push(
                                context,
                                Center(
                                  child: CircularProgressIndicator(),
                                ));
                            Timer(Duration(seconds: 3), () {
                              pop(context);
                              push(context, ChatScreen());
                            });
                          } else {
                            snack(context, 'Paragraph is too short !');
                          }
                        },
                        icon: Icon(Icons.send, color: Colors.green)),
                    enabledBorder: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(),
                    hintText: 'A paragraph with more than 100 words...'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  uploadFile(fileName, fileBytes) async {
    try {
      print('In uploadFile');
      Reference storeRef = FirebaseStorage.instance.ref();

      Reference pdfRef = storeRef.child('pdfs/$fileName');

      String cont = "";

      await pdfRef.putData(fileBytes).then((p0) {
        debugPrint('File Uploaded Successfully !!! $p0');
        pdfRef.getDownloadURL().then((value) async {
          // debugPrint('Value is : $value');
          Map<String, dynamic> pdfUrl = {'url': value};

          final res = await http.post(Uri.parse('http://localhost:3000/parse'),
              headers: {'Content-Type': 'application/json'},
              body: jsonEncode(pdfUrl));

          print("Got the response : ${res.body}");
          cont = res.body;
        });
      });

      final Map<String, dynamic> data = {
        'ques': 'Can you summarize this paragraph for me ?',
        'context': cont,
      };

      // CircularProgressIndicator();
      final response = await http.post(
          Uri.parse('http://localhost:3000/question'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(data));

      print("Response is : ${response.body}");
    } catch (e) {
      print("Got error ${e.toString()}");
    }
  }
}
