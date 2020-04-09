import 'package:flutter/material.dart';
import 'package:topicos_productos/pages/productos_page.dart';
 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ProductosFirebase',
      home: ProductosPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}