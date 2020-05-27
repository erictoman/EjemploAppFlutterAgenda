import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:contact_picker/contact_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter_app/Evento.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;
import 'package:flutter_datepicker_single/flutter_datepicker_single.dart';
import 'package:url_launcher/url_launcher.dart';



class verEventos extends StatefulWidget{
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<verEventos>{
  final ContactPicker _contactPicker = new ContactPicker();
  var txt = TextEditingController();
  var dateRange = TextEditingController();
  var time = TextEditingController();
  var location = TextEditingController();
  var contacto = TextEditingController();
  var descripcion = TextEditingController();
  var dateYear = TextEditingController();
  var dateMonth = TextEditingController();
  var status= "Pendiente";
  var categoria= "Cita";
  var tipo= "Fecha";
  var month="";
  DataTable local;
  var year = "";
  DateTime fechaDateTime=null;
  List eventos=[];
  List<DateTime> rangofechas;
  _openMap(String address) async {
    String url = 'https://www.google.com/maps/search/?api=1&query=$address';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  _OpenCall(String phone) async {
    String url = 'tel:$phone';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  Future<Null> _selectDate(BuildContext context) async{
    final DateTime picked = await showDatePicker(context: context, initialDate: DateTime.now(),firstDate: DateTime(DateTime.now().year-3),lastDate:  DateTime(DateTime.now().year+3));
    if(picked!=null){
      txt.text=picked.day.toString()+"/"+picked.month.toString()+"/"+picked.year.toString();
      fechaDateTime=picked;
    }
  }
  Future<Null> _selectYear(BuildContext context) async{
    final DateTime picked = await showDatePicker(context: context, initialDate: DateTime.now(),firstDate: DateTime(DateTime.now().year-3),lastDate:  DateTime(DateTime.now().year+3),initialDatePickerMode: DatePickerMode.year);
    if(picked!=null){
      dateYear.text=picked.year.toString();
    }
  }
  Future<Null> _selectDateRange(BuildContext context)async{
    final List<DateTime> picked = await DateRagePicker.showDatePicker(
        context: context,
        initialFirstDate: new DateTime.now(),
        initialLastDate: (new DateTime.now()).add(new Duration(days: 7)),
        firstDate: new DateTime(2015),
        lastDate: new DateTime(2020)
    );
    if(picked!=null && picked.length == 2){
      rangofechas=picked;
      dateRange.text= picked[0].day.toString()+"/"+picked[0].month.toString()+"/"+picked[0].year.toString()+"-"+picked[1].day.toString()+"/"+picked[1].month.toString()+"/"+picked[1].year.toString();
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
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text("Buscar por:",textAlign: TextAlign.left,),
                  DropdownButton<String>(
                    items: <String>['Fecha', 'Rango', 'Mes','Año'].map((String value) {
                      return new DropdownMenuItem<String>(
                        value: value,
                        child: new Text(value),
                      );
                    }).toList(),
                    onChanged: (newVal) {
                      setState(() {
                        this.tipo=newVal;
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
                    value: this.tipo,
                  ),
                  if(this.tipo=="Fecha")TextField(
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
                  if(this.tipo=="Rango")TextField(
                    controller: dateRange,
                    onTap: () async {
                      _selectDateRange(context);
                    },
                    readOnly: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Rango de fechas',
                    ),
                  ),
                  if(this.tipo=="Año")TextField(
                    controller: dateYear,
                    onTap: () async {
                      DateTime selected = await showYearPicker(context: context, initialDate: DateTime.now());
                      if(selected!=null){
                        dateYear.text=selected.year.toString();
                      }
                    },
                    readOnly: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Año',
                    ),
                  ),
                  if(this.tipo=="Mes")TextField(
                    controller: dateMonth,
                    onTap: () async {
                      DateTime selected = await showMonthPicker(context: context, initialDate: DateTime.now());
                      if(selected!=null){
                        dateMonth.text=selected.month.toString();
                      }
                    },
                    readOnly: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Mes',
                    ),
                  ),
                  Text("Categoria:",textAlign: TextAlign.left),
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
                  ButtonTheme(
                    minWidth: 800.0,
                    height: 30.0,
                    child: RaisedButton(
                      onPressed:() async{
                        String query="";
                        switch (this.tipo) {
                          case "Fecha":
                            {
                              if(fechaDateTime!=null){
                                String fecha = "${fechaDateTime.year.toString()}-${fechaDateTime.month.toString().padLeft(2,'0')}-${fechaDateTime.day.toString().padLeft(2,'0')}";
                                query = "date(fecha)=date('$fecha') and categoria='$categoria'";
                                Database database = await checkDatabase();
                                List Events = await search(database,query);
                                if(Events.length>0){
                                  setState(() {
                                    this.eventos=Events;
                                  });
                                }else{
                                  setState(() {
                                    this.eventos=[];
                                  });
                                }
                              }
                            }
                            break;
                          case "Año":
                            {
                              if(dateYear.text.toString()!=null){
                                String s = dateYear.text;
                                query = "strftime('%Y',fecha)='$s' and categoria='$categoria'";
                                //Fluttertoast.showToast(msg: query,toastLength: Toast.LENGTH_LONG);
                                Database database = await checkDatabase();
                                List Events = await search(database,query);
                                if(Events.length>0){
                                  setState(() {
                                    this.eventos=Events;
                                  });
                                }else{
                                  setState(() {
                                    this.eventos=[];
                                  });
                                }
                              }
                            }
                            break;
                          case "Mes":
                            {
                              if(dateMonth.text.toString()!=null){
                                String s = dateMonth.text;
                                s=s.padLeft(2,'0');
                                query = "strftime('%m',fecha)='$s' and categoria='$categoria'";
                                Fluttertoast.showToast(msg: query,toastLength: Toast.LENGTH_LONG);
                                Database database = await checkDatabase();
                                List Events = await search(database,query);
                                if(Events.length>0){
                                  setState(() {
                                    this.eventos=Events;
                                  });
                                }else{
                                  setState(() {
                                    this.eventos=[];
                                  });
                                }
                              }
                            }
                            break;
                          case "Rango":
                            {
                              if(rangofechas!=null){
                                String fecha1 = "${rangofechas[0].year.toString()}-${rangofechas[0].month.toString().padLeft(2,'0')}-${rangofechas[0].day.toString().padLeft(2,'0')}";
                                String fecha2 = "${rangofechas[1].year.toString()}-${rangofechas[1].month.toString().padLeft(2,'0')}-${rangofechas[1].day.toString().padLeft(2,'0')}";
                                query = "fecha between date('$fecha1') and date('$fecha2') and categoria='$categoria'";
                                Fluttertoast.showToast(msg: query,toastLength: Toast.LENGTH_LONG);
                                Database database = await checkDatabase();
                                List Events = await search(database,query);
                                if(Events.length>0){
                                  setState(() {
                                    this.eventos=Events;
                                  });
                                }else{
                                  setState(() {
                                    this.eventos=[];
                                  });
                                }
                              }
                            }
                            break;
                        }
                      },
                      child: Text("Buscar",style: TextStyle(color: Colors.white),)
                    ),
                  ),
                  SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                        child:
                        DataTable(
                              rows:[
                                if(this.eventos!=null)for(Evento e in eventos)
                                  DataRow(
                                      cells: [
                                        DataCell(Text(e.categoria)),
                                        DataCell(Text(e.fecha)),
                                        DataCell(Text(e.Hora)),
                                        DataCell(Text(e.Descripcion)),
                                        DataCell(Text(e.Ubicacion),onTap: () async{
                                          await _openMap(e.Ubicacion.toString());
                                        }),
                                        DataCell(Text(e.Status)),
                                        DataCell(Text(e.contacto),
                                            onTap: () async{
                                              _OpenCall(e.contacto.split(":")[1]);
                                            }
                                        ),
                                        DataCell(ButtonTheme(
                                        height: 30.0,
                                          child: RaisedButton(
                                          onPressed: () async{
                                              Contact contact = await _contactPicker.selectContact();
                                              if(contact!=null){
                                                e.contacto=contact.fullName+":"+contact.phoneNumber.number;
                                                Database database = await checkDatabase();
                                                cambiarContacto(database, e);
                                                setState(() {
                                                  this.eventos=this.eventos;
                                                });
                                              }
                                          },
                                            child: Text("Cambiar Contacto",style: TextStyle(color: Colors.white),),
                                            ),
                                            ),
                                            ),
                                        DataCell(ButtonTheme(
                                          height: 30.0,
                                          child: RaisedButton(
                                              onPressed: () async{
                                                LocationResult result = await LocationPicker.pickLocation(context, "AIzaSyBkbxwBcttJGaSupqJcYPFCx1LpWtyfIQ4");
                                                if(result!=null){
                                                  e.Ubicacion=result.address.toString();
                                                  Database database = await checkDatabase();
                                                  cambiarUbicacion(database,e);
                                                  setState(() {
                                                    this.eventos=this.eventos;
                                                  });
                                                }
                                              },
                                              child: Text("Cambiar ubicacion",style: TextStyle(color: Colors.white),),
                                            ),
                                          ),
                                        ),
                                        DataCell(
                                          DropdownButton<String>(
                                            items: <String>['Pendiente', 'Realizado', 'Aplazado'].map((String value) {
                                              return new DropdownMenuItem<String>(
                                                value: value,
                                                child: new Text(value),
                                              );
                                            }).toList(),
                                            onChanged: (newVal) async {
                                              Database database = await checkDatabase();
                                              e.Status=newVal;
                                              cambiarStatus(database,e);
                                              setState(() {
                                                this.eventos=this.eventos;
                                              });
                                            },
                                              style:
                                                TextStyle(
                                                  color: Colors.black
                                                ),
                                              isExpanded: true,
                                              underline: Container(
                                              height: 2,
                                              color: Colors.blue,
                                            ),value: e.getStatus(),
                                          ),
                                        ),
                                        DataCell(ButtonTheme(
                                            height: 30.0,
                                            child: RaisedButton(
                                              onPressed: () async{
                                                  Database database = await checkDatabase();
                                                  borrarEvento(database,e);
                                                  List aux;
                                                  for(int i = 0;i<this.eventos.length;i++){
                                                    if(this.eventos[i].id!=e.id){
                                                      aux.add(this.eventos[i]);
                                                    }
                                                  }
                                                  setState(() {
                                                    this.eventos=aux;
                                                  });
                                              },
                                              child: Text("Eliminar",style: TextStyle(color: Colors.white),),color: Colors.red,
                                            ),
                                          ),
                                        )
                                      ]
                                  )
                              ],
                              columns: [
                                DataColumn(
                                  label: Text("Categoria"),
                                ),
                                DataColumn(
                                  label: Text("Fecha"),
                                ),
                                DataColumn(
                                  label: Text("Hora"),
                                ),
                                DataColumn(
                                  label: Text("Descripcion")
                                ),
                                DataColumn(
                                  label: Text("Ubicacion")
                                ),
                                DataColumn(
                                  label: Text("Status")
                                ),
                                DataColumn(
                                  label: Text("Contacto")
                                ),
                                DataColumn(
                                    label: Text("Cambiar Contacto")
                                ),
                                DataColumn(
                                    label: Text("Cambiar Ubicacion")
                                ),
                                DataColumn(
                                    label: Text("Cambiar Status")
                                ),
                                DataColumn(
                                    label: Text("Eliminar")
                                )
                              ]
                        )
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

  void cambiarStatus(Database database,Evento e) async{
    database.update("Eventos", {'Status':e.Status}, where: "id = ?", whereArgs:[e.id]);
  }

  void borrarEvento(Database database,Evento e) async{
    database.delete("Eventos", where: "id = ?", whereArgs:[e.id]);
  }

  void cambiarUbicacion(Database database,Evento e) async{
    database.update("Eventos", {'Ubicacion':e.Ubicacion}, where: "id = ?", whereArgs:[e.id]);
  }
  void cambiarContacto(Database database,Evento e) async{
    database.update("Eventos", {'contacto':e.contacto}, where: "id = ?", whereArgs:[e.id]);
  }

  Future<Database> checkDatabase() async{
    final Future<Database> database = openDatabase(join(await getDatabasesPath(), 'eventos.db'),version: 1);
    return database;
  }

  Future<List> search(Database database,String query) async{
    Future<List<Evento>> getCustomers() async {
      final List<Map<String, dynamic>> maps = await database.query("Eventos",where: query);
      return List.generate(maps.length, (i) {
        return Evento(
            id: maps[i]['id'],
            categoria: maps[i]['categoria'],
            fecha: maps[i]['fecha'],
            Hora: maps[i]['Hora'],
            Descripcion: maps[i]['Descripcion'],
            Ubicacion: maps[i]['Ubicacion'],
            Status: maps[i]['Status'],
            contacto: maps[i]['contacto']
        );
      });
    }
    List lista = await getCustomers();
    return lista;
  }
}