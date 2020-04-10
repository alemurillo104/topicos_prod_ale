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
   final productosRef = FirebaseDatabase.instance.reference().child('productos');
   

   Future<List<Product>> getProductos() async { 
      DataSnapshot snap = await database.once();
      Map<dynamic,dynamic> dataS= snap.value['productos'];
      
      final list=new Productos.fromJsonMap(dataS);

      final products= list.items;

      _productos.addAll(products);

      productosSink(list.items);
      
      return list.items;
 
   }

  void setProducto(Product producto){
    final json= productToJson(producto);
    database.child('productos').push().set(json);
  } 

  void updateProducto(String key,Product producto){
    database.child('productos/'+key).update(productToJson(producto));
  }
  void delProduct(String key){
    database.child('productos/'+key).remove();
  }

}