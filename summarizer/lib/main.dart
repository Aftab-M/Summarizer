// import 'dart:html';
import 'dart:typed_data';
import 'package:path/path.dart' as path;
import 'package:file_picker/file_picker.dart';
import 'package:file_picker/src/platform_file.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:summarizer/firebase_options.dart';
import 'dart:js' as js;

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
      home: const MyHomePage(title: 'Summarizer'),
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
  @override
  Widget build(BuildContext context) {
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
          ],
        ),
      ),
    );
  }

  uploadFile(fileName, fileBytes) async {
    try {
      Reference storeRef = FirebaseStorage.instance.ref();

      Reference pdfRef = storeRef.child('pdfs/$fileName');
      // await pdfRef
      //     .putData(fileBytes)
      //     .then((p0) => debugPrint('File Uploaded Successfully !!!'));
      js.context.callMethod('sendback', ['abc']);
    } catch (e) {
      print("Got error ${e.toString()}");
    }
  }
}
