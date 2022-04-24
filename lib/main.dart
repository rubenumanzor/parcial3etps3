import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:parcial3etps3/model/Restaurante.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(ConsumirApi());
}

class ConsumirApi extends StatefulWidget {
  @override
  State<ConsumirApi> createState() => _ConsumirApiState();
}

class _ConsumirApiState extends State<ConsumirApi> {
  late Future<List<Restaurante>> _listadoRestaurante;

  Future<List<Restaurante>> _getCatalogo() async {
    final Response = await http.get(Uri.parse(
        "https://www.thecocktaildb.com/api/json/v1/1/search.php?s=mojito"));

    String cuerpo;
    List<Restaurante> lista = [];

    if (Response.statusCode == 200) {
      print(Response.body);
      cuerpo = utf8.decode(Response.bodyBytes);
      final jsondata = jsonDecode(cuerpo);
      for (var item in jsondata['drinks']) {
        lista.add(Restaurante(item['strDrink'], item['strDrinkThumb'],
            item['idDrink'], item['strCategory'], item['strInstructions']));
      }
    } else {
      throw Exception("falla en conexion estado 500");
    }
    return lista;
  }

  @override
  void initState() {
    super.initState();
    _listadoRestaurante = _getCatalogo();
  }

  @override
  Widget build(BuildContext context) {
    var futureBuilder = FutureBuilder(
      future: _listadoRestaurante,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView(
            children: _listadoRestaurantes(snapshot.data),
          );
        } else {
          print(snapshot.error);
          return Text("Error");
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Maurita Restaurante',
      home: Scaffold(
        backgroundColor: const Color(0xff1d000d),
        body: Column(children: [
          SizedBox(
            height: 10,
          ),
          Container(
            height: 50,
            width: 250,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(
                      "https://www.thecocktaildb.com/images/logo.png"),
                  scale: 0.05),
            ),
          ),
          Expanded(child: futureBuilder)
        ]),
      ),
    );
  }

  List<Widget> _listadoRestaurantes(data) {
    List<Widget> rest = [];
    for (var itempk in data) {
      rest.add(Card(
        elevation: 3.0,
        color: const Color(0xff2E0E1D),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            SizedBox(height: 8),
            Container(
              height: 150,
              width: 150,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(itempk.strDrinkThumb), scale: 0.05),
              ),
            ),
            SizedBox(height: 8),
            Text(itempk.strDrink,
                style: TextStyle(
                    color: Colors.amber,
                    fontWeight: FontWeight.bold,
                    fontSize: 18)),
            SizedBox(height: 8),
            Text("Code: " + itempk.idDrink,
                style: TextStyle(color: Colors.white)),
            Text("Categoria: " + itempk.strCategory,
                style: TextStyle(color: Colors.white)),
            SizedBox(height: 12),
            Text("Indicaciones: ",
                style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 17)),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.only(left: 25, right: 25),
              child: Text(itempk.strInstructions,
                  style: TextStyle(
                      color: Colors.white, fontStyle: FontStyle.italic)),
            ),
            SizedBox(height: 15),
          ],
        ),
      ));
    }
    return rest;
  }
}
