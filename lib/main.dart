import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/newEvent.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_app/Evento.dart';
import 'package:flutter_app/verEventos.dart';



void main() {
  runApp(new MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: new ThemeData(
      primaryColor: Colors.blue,
      primaryColorDark: Colors.black,
      accentColor: Colors.blueAccent,
    ),
    home: new _Principal(),
    routes:{
      '/newEvent': (BuildContext context) => new newEvent(),
      '/verEventos':(BuildContext context) => new verEventos()
    },
  ));
}

class _Principal  extends StatefulWidget  {
  @override
  _PrincipalState createState() => new _PrincipalState();
}

class _PrincipalState extends State<_Principal> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Agenda'),
        ),
        body: Builder(builder: (context) {
          return Center(
              child:SizedBox(
                width: 400, // set this
                child:Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ButtonTheme(
                      minWidth: 800.0,
                      height: 30.0,
                      child: RaisedButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed('/newEvent');
                        },
                        child: Text("Agregar evento",style: TextStyle(color: Colors.white),),
                      ),
                    ),
                    ButtonTheme(
                      minWidth: 800.0,
                      height: 30.0,
                      child: RaisedButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed('/verEventos');
                        },
                        child: Text("Ver eventos",style: TextStyle(color: Colors.white),),
                      ),
                    ),
                  ],
                ),
              )
          );
        }),
    );
  }
  @override
  void initState() {
    super.initState();
    StartDatabase();
  }
  void StartDatabase() async{
    final Future<Database> database = openDatabase(
        join(await getDatabasesPath(), 'eventos.db'),onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE Eventos(id INTEGER PRIMARY KEY AUTOINCREMENT, categoria TEXT, fecha TIME,Hora TIME,Descripcion TEXT,Ubicacion TEXT,Status TEXT,contacto TEXT);",
        );
      },version: 1
    );
    if(database==null){
      print("Error");
    }
  }
  void addToDatabase(Database database,Evento e) async{
    database.insert("Eventos",e.toMap());
  }
  Future<Database> checkDatabase() async{
    final Future<Database> database = openDatabase(join(await getDatabasesPath(), 'eventos.db'),version: 1);
    return database;
  }
}