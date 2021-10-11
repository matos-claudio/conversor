import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const url = "https://api.hgbrasil.com/finance?format=json&key=eda3dc32";

void main(){
  runApp(const MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late double dolar;
  late double euro;

  final realController = TextEditingController();
  final dollarController = TextEditingController();
  final euroController = TextEditingController();

  void _realChanged() {
    print("OK");
  }

  void _dolarChanged() {

  }

  void _euroChanged() {

  }

  @override
  Widget build(BuildContext context) {
    const titleAppBar = Text('Conversor de moedas');
    const circularProgress = Center(
      child: CircularProgressIndicator(
        color: Colors.amber,
      )
    );
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title:titleAppBar,
        centerTitle: true,
        backgroundColor: Colors.amber,
      ),
      body: FutureBuilder<Map>(
        future: getData(),
        builder: (context, snapshot){
          switch(snapshot.connectionState){
            case ConnectionState.none:
            case ConnectionState.waiting:
              return circularProgress;
            default:
              if(snapshot.hasError) {
                return Center(
                    child: Text("Erro ao carregar dados.", style: TextStyle(color: Colors.amber, fontSize: 16), textAlign: TextAlign.center)
                );
              } else {
                dolar = snapshot.data!["results"]["currencies"]["USD"]["buy"];
                euro = snapshot.data!["results"]["currencies"]["EUR"]["buy"];
                return SingleChildScrollView(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Icon(Icons.monetization_on, size: 150.0, color: Colors.amber),
                      buildTextField("Reais", "R\$", realController, _realChanged),
                      Divider(),
                      buildTextField("Dolar", "US\$", dollarController, _dolarChanged),
                      Divider(),
                      buildTextField("Euro", "E", euroController, _euroChanged),
                    ],
                  ),
                );
              }
          }
        }
      ),
    );
  }
}

Future<Map> getData() async {
  http.Response response = await http.get(Uri.parse(url));
  return json.decode(response.body);
}

Widget buildTextField(String label, String prefix, TextEditingController c, Function f) {
  return TextField(
    controller: c,
    decoration: InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.amber),
      border: OutlineInputBorder(),
      prefixText: prefix,
    ),
    style: TextStyle(
        color: Colors.amber,
        fontSize: 25.0
    ),
    onChanged: f,
  );
}