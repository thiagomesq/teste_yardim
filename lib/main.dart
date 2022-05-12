import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'dart:convert';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [Locale('pt', 'BR')],
      home: JSONToCSV(),
    );
  }
}

class JSONToCSV extends StatefulWidget {
  const JSONToCSV({Key? key}) : super(key: key);

  @override
  State<JSONToCSV> createState() => _JSONToCSVState();
}

class _JSONToCSVState extends State<JSONToCSV> {
  final _formKey = GlobalKey<FormState>();
  final jsonTextController = TextEditingController();
  final csvTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        child: const Text('Converter'),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            String jsonText = jsonTextController.text;
                            final json = jsonDecode(jsonText);
                            String csv = '';
                            if (json is List) {
                              for (String key in json[0].keys) {
                                csv += key + ',';
                              }
                              csv = csv.substring(0, csv.length - 1) + "\n";
                              for (int i = 0; i < json.length; i++) {
                                json[i].forEach((key, value) {
                                  csv += value.toString() + ',';
                                });
                                csv = csv.substring(0, csv.length - 1) + "\n";
                              }
                              setState(() {
                                csvTextController.text = csv;
                              });
                            } else {
                              for (String key in json.keys) {
                                csv += key + ',';
                              }
                              csv = csv.substring(0, csv.length - 1) + "\n";
                              json.forEach((key, value) {
                                csv += value.toString() + ',';
                              });
                              csv = csv.substring(0, csv.length - 1) + "\n";
                              setState(() {
                                csvTextController.text = csv;
                              });
                            }
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        child: const Text('Limpar'),
                        onPressed: () {
                          setState(() {
                            jsonTextController.clear();
                            csvTextController.clear();
                          });
                        },
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: TextFormField(
                    controller: jsonTextController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), labelText: 'JSON'),
                    minLines: 7,
                    maxLines: 50,
                    validator: (value) {
                      return value!.isEmpty
                          ? 'Campo vazio! Entre com um valor válido!'
                          : null;
                    },
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    enabled: false,
                    controller: csvTextController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), labelText: 'CSV'),
                    minLines: 7,
                    maxLines: 50,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
