
import 'package:flutter/material.dart';
import 'package:topicos_productos/models/product2_model.dart';

import 'package:topicos_productos/providers/productos_provider.dart';

class ProductosPage extends StatefulWidget {
  ProductosPage({Key key}) : super(key: key);

  @override
  _ProductosPageState createState() => _ProductosPageState();
}

class _ProductosPageState extends State<ProductosPage> {
 final prodProvider= new ProductosProvider();

  final _idController = TextEditingController();
  final _nombreController = TextEditingController();
  final _cantidadController = TextEditingController();
  final _precioController = TextEditingController();

  @override
  void initState() {
    prodProvider.productosStream.listen((data) => {
      //print(data),
      prodProvider.getProductos()
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //prodProvider.getProductos();
    return Scaffold(
       appBar: AppBar(
         title: Text('Productos- Firebase'),
       ),
       body:_listaProdStream(context),
        floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showInput(context);
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
        )
    );
  }

  Widget _listaProdStream(BuildContext context) {
   
  prodProvider.getProductos();
    return StreamBuilder(
      stream: prodProvider.productosStream,
      builder: (BuildContext context, AsyncSnapshot <List<Product>> snap) {
        if (snap.hasData) {
          //final da=snap.data ;
          //print(da[0].nombre);
          List<Product> productos=snap.data;
          //print(productos.length);
          return _cardSt(productos,context);
          //print(productos[2].nombre);
          //print(productos.length);
          //return Text('hay data');
        }else{
          return Center(child: Text('Lista Vacia'),);
        }
      },
    );
  }
  
  Widget _cardSt(List<Product> _listaproductos, BuildContext context) {
 
   return ListView.builder(
          shrinkWrap: true,
          itemCount: _listaproductos.length,
          itemBuilder: (BuildContext context, int index) {
            //print(_listaproductos[index].key);
             Product prod2= new Product.key(
              key:_listaproductos[index].key ,
              id: _listaproductos[index].id,
              nombre: _listaproductos[index].nombre,
              cantidad: _listaproductos[index].cantidad,
              precio: _listaproductos[index].precio,
              createdAt: _listaproductos[index].createdAt
            );
           /* Product prod= new Product(
              id: _listaproductos[index].id,
              nombre: _listaproductos[index].nombre,
              cantidad: _listaproductos[index].cantidad,
              precio: _listaproductos[index].precio,
            );*/
            return card(prod2);
          }
   );
  }
  
 
  Widget card(Product producto){
    
    return Card(
      elevation: 12.0,
      borderOnForeground: true,
      margin: EdgeInsets.all(14.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(124.0),
        child: Container(
          child: ListTile(
              //onTap: () =>_updateInput(context, producto) ,
              leading: Icon(Icons.add_comment),
              title: Text(producto.nombre, style: TextStyle(fontSize: 20.0)),
              subtitle: contenido(producto.id, producto.cantidad, producto.precio,producto.createdAt),
          ),
          margin: EdgeInsets.all(10.0),
          ),
      ),
    );
  }

  
  Widget contenido(String id, double cantidad, double precio,String create) {
    //print(create+'hey');
    if (create.toString()=='null') {
      return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Codigo: '+ id.toString()),
        Text('Cantidad: '+ cantidad.toString()),
        Text('Precio: '+ precio.toString()),
      ],
    );
    }else{
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Codigo: '+ id.toString()),
          Text('Cantidad: '+ cantidad.toString()),
          Text('Precio: '+ precio.toString()),
          Text('Creado: '+ create.toString()),
        ],
      );
    }
    
  }

  //----waaa
  
  void _showInput(BuildContext context) async{
    _idController.clear();
    _nombreController.clear();
    _cantidadController.clear();
    _precioController.clear();
    await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: _inputs(),
            actions: <Widget>[
                _actions(context)
            ],
          );
        }
    );
  }

  Widget _inputs() {
    return Column(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _idController,
              autofocus: true,
              decoration: InputDecoration(
                labelText: 'ID',
              ),
            ),
          ),
          Expanded(
            child: TextField(
              controller: _nombreController,
              decoration: InputDecoration(
                labelText: 'Nombre',
              ),
            ),
          ),
          Expanded(
            child: TextField(
              controller: _cantidadController,
              decoration: InputDecoration(
                labelText: 'Cantidad',
              ),
            ),
          ),
          Expanded(
            child: TextField(
              controller: _precioController,
              decoration: InputDecoration(
                labelText: 'Precio',
              ),
            ),
          )
        ],
      );
    }

  _actions(BuildContext context) {
     return Row(
       children: <Widget>[ 
         FlatButton(
            child: const Text('Cancelar'),
            onPressed: () {
              Navigator.pop(context);
            }
         ),
         FlatButton(
            child: const Text('Guardar'),
            onPressed: () {
              Product product= new Product(
                id: _idController.text.toString(),
                nombre: _nombreController.text.toString(), 
                cantidad:double.parse(_cantidadController.text), 
                precio: double.parse(_precioController.text),
                createdAt: DateTime.now().toString()
              );
              prodProvider.setProducto(product);
              Navigator.pop(context);
            }
         )
       ],
     );
  }

}