import 'dart:convert';

class Productos{
  List<Product> items = new List();
  Productos();

  Productos.fromJsonMap(Map<dynamic,dynamic> jsonMap){
   
    jsonMap.forEach((key,value){
      final valorkey= {"key": key};
      String keyValue= json.encode(valorkey);
      final valor= json.encode(value);
      final nuevoCompl= productFromJson2(keyValue, valor);
      items.add(nuevoCompl);
    });
  }
}


Product productFromJson2(String key,String str) => Product.fromJsonkey(json.decode(key),json.decode(str));
Product productFromJson(String str) => Product.fromJson(json.decode(str));


Map<String, dynamic> productToJson(Product data) => data.toJson();
class Product {
    String key;
    String id;
    String nombre;
    double cantidad;
    double precio;
    String createdAt;

    Product({
        this.id,
        this.nombre,
        this.cantidad,
        this.precio,
        this.createdAt,
    });
    Product.key({
        this.key,
        this.id,
        this.nombre,
        this.cantidad,
        this.precio,
        this.createdAt,
    });

    factory Product.fromJson(Map<String, dynamic> json) => Product(

        id: json["id"].toString(),
        nombre: json["nombre"],
        cantidad: double.parse(json["cantidad"].toString()),
        precio:   double.parse(json["precio"].toString()),
        createdAt: json["createdAt"].toString(),
    );

    factory Product.fromJsonkey(Map<String, dynamic> jsonKey, Map<String, dynamic> json) => Product.key(
        key: jsonKey["key"],
        id: json["id"].toString(),
        nombre: json["nombre"],
        cantidad: double.parse(json["cantidad"].toString()),
        precio:   double.parse(json["precio"].toString()),
        createdAt: (json["createdAt"]).toString(),
    );
    

    Map<String, dynamic> toJson() => {
        "id": id.toString(),
        "nombre": nombre,
        "cantidad": cantidad.toString(),
        "precio": precio.toString(),
        "createdAt": createdAt.toString(),
    };
  
}