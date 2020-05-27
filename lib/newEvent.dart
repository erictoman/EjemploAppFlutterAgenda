import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:contact_picker/contact_picker.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter_app/Evento.dart';

class newEvent extends StatefulWidget{
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<newEvent>{
  final ContactPicker _contactPicker = new ContactPicker();
  var txt = TextEditingController();
  var time = TextEditingController();
  var location = TextEditingController();
  var contacto = TextEditingController();
  var descripcion = TextEditingController();
  var status= "Pendiente";
  var categoria= "Cita";
  GlobalKey<FormState> _key = new GlobalKey();
  Future<Null> _selectTime(BuildContext context) async{
    final TimeOfDay picked = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if(picked!=null){
      time.text=picked.hour.toString().padLeft(2,'0')+":"+picked.minute.toString().padLeft(2,'0');;
    }
  }
  Future<Null> _selectDate(BuildContext context) async{
    final DateTime picked = await showDatePicker(context: context, initialDate: DateTime.now(),firstDate: DateTime(DateTime.now().year-3),lastDate:  DateTime(DateTime.now().year+3));
    if(picked!=null){
      txt.text=picked.day.toString().padLeft(2,'0')+"/"+picked.month.toString().padLeft(2,'0')+"/"+picked.year.toString().padLeft(2,'0');
    }
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          leading: new IconButton(
            icon: new Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text('Agenda'),
        ),
        body: Builder(builder: (context) {
          return Center(
              child:SizedBox(
                width: 400, // set this
                child:Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Categoria:",textAlign: TextAlign.left,),
                    DropdownButton<String>(
                      items: <String>['Cita', 'Junta', 'Entrega de proyecto','Examen','Otro'].map((String value) {
                        return new DropdownMenuItem<String>(
                          value: value,
                          child: new Text(value),
                        );
                      }).toList(),
                      onChanged: (newVal) {
                        setState(() {
                          this.categoria=newVal;
                        });
                      },
                      style: TextStyle(
                          color: Colors.black
                      ),
                      isExpanded: true,
                      underline: Container(
                        height: 2,
                        color: Colors.blue,
                      ),
                      value: this.categoria,
                    ),
                    TextField(
                      controller: txt,
                      onTap: () async {
                        _selectDate(context);

                      },
                      readOnly: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Fecha',
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: time,
                      onTap: () async {
                        _selectTime(context);
                      },
                      readOnly: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Hora',
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: descripcion,
                      obscureText: false,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Descripcion',
                        contentPadding: const EdgeInsets.symmetric(vertical: 30.0,horizontal: 20),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: location,
                      onTap: () async {
                        LocationResult result = await LocationPicker.pickLocation(context, "AIzaSyBkbxwBcttJGaSupqJcYPFCx1LpWtyfIQ4");
                        if(result!=null){
                          location.text=result.address.toString();
                        }
                      },
                      readOnly: true,
                      obscureText: false,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        focusColor: Colors.blue,
                        labelText: 'Ubicacion',
                      ),
                    ),
                    SizedBox(height: 10),
                    Text("Status:",textAlign: TextAlign.left,),
                    DropdownButton<String>(
                      items: <String>['Pendiente', 'Realizado', 'Aplazado'].map((String value) {
                        return new DropdownMenuItem<String>(
                          value: value,
                          child: new Text(value),
                        );
                      }).toList(),
                      onChanged: (newVal) {
                        setState(() {
                          this.status=newVal;
                        });
                      },
                      style: TextStyle(
                          color: Colors.black
                      ),
                      isExpanded: true,
                      underline: Container(
                        height: 2,
                        color: Colors.blue,
                      ),
                      value: this.status,
                    ),
                    SizedBox(height: 10),
                    Text("Contacto:",textAlign: TextAlign.left,),
                    SizedBox(height: 10),
                    TextField(
                      controller: contacto,
                      onTap: () async {
                        Contact contact = await _contactPicker.selectContact();
                        if(contact!=null){
                          contacto.text=contact.fullName+":"+contact.phoneNumber.number;
                        }
                      },
                      readOnly: true,
                      obscureText: false,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Contacto',
                      ),
                    ),
                    ButtonTheme(
                      minWidth: 800.0,
                      height: 30.0,
                      child: RaisedButton(
                          onPressed:() async{
                            Database database = await checkDatabase();
                            Evento e = new Evento(
                                id:0,
                                categoria:categoria,
                                fecha: ((txt.text.toString().split("/")).reversed).join("-")+" "+time.text.toString(),
                                Hora:time.text.toString(),
                                Descripcion:descripcion.text.toString(),
                                Ubicacion:location.text.toString(),
                                Status:status,
                                contacto:contacto.text.toString());
                            addToDatabase(database, e);
                            Navigator.pop(context);
                        },
                        child: Text("Guardar evento",style: TextStyle(color: Colors.white),),
                      ),
                    )
                  ],
                ),
              )
          );
        }),
    );
  }
  void addToDatabase(Database database,Evento e) async{
    database.insert("Eventos",e.toMap());
  }
  Future<Database> checkDatabase() async{
    final Future<Database> database = openDatabase(join(await getDatabasesPath(), 'eventos.db'),version: 1);
    return database;
  }
}