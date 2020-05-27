class Evento {
  int id;
  String categoria;
  String fecha;
  String Hora;
  String Descripcion;
  String Ubicacion;
  String Status;
  String contacto;
  Evento({this.id,this.categoria, this.fecha, this.Hora,this.Descripcion,this.Ubicacion,this.Status,this.contacto});
  Map<String, dynamic> toMap() {
    return {
      'categoria': categoria,
      'fecha': fecha,
      'Hora': Hora,
      'Descripcion': Descripcion,
      'Ubicacion': Ubicacion,
      'Status': Status,
      'contacto': contacto
    };
  }
  String getStatus(){
    return this.Status;
  }
}