import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:topicos_productos/models/product2_model.dart';



class ProductosProvider{


   List<Product> _productos = new List();

   final _productosStreamController = StreamController<List<Product>>.broadcast();

   Function(List<Product>) get productosSink => _productosStreamController.sink.add;

   Stream<List<Product>> get productosStream => _productosStreamController.stream;
   
   void disposeStreams(){
     _productosStreamController?.close();
     
   }

   final database = FirebaseDatabase.instance.reference();
   //final database = FirebaseDatabase();

   Future<List<Product>> getProductos() async { 
      /*final resp= await FirebaseDatabase.instance
                .reference()
                .child('productos')
                .orderByChild('createdAt')
                .limitToFirst(10)
                .once();
        */        
      
      //final wu= await resp.once();
     // print(resp.value);
      //DataSnapshot snap = await database.child('productos').orderByChild('createdAt').limitToFirst(10).once();
      DataSnapshot snap = await database.once();
      Map<dynamic,dynamic> dataS= snap.value['productos'];
      //print(dataS);
      final list=new Productos.fromJsonMap(dataS);
      
      //print(list.items[0].createdAt);
      //print(list.items[2].key);
      final products= list.items;

      _productos.addAll(products);

      productosSink(list.items);
      
      return list.items;
 
   }

    void setProducto(Product producto){
    final json= productToJson(producto);
    database.child('productos').push().set(json);
  } //si le pongo Future o algo asi me devuelve una funcion(funcion callback) 
    //con la key del objeto insertado
}