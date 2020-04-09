
import 'dart:convert';

import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:topicos_productos/models/product2_model.dart';

import 'package:topicos_productos/providers/productos_provider.dart';

class ProductosPage extends StatefulWidget {
  ProductosPage({Key key}) : super(key: key);

  @override
  _ProductosPageState createState() => _ProductosPageState();
}

class _ProductosPageState extends State<ProductosPage> {
 //final globalKey = GlobalKey<ScaffoldState>(); 
 
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
      primary: true,
       //key: globalKey,
       appBar: AppBar(
         title: Text('Productos- Firebase'),
         actions: <Widget>[
         _iconInfo(context)
        ],
       ),
       body: _listaProdu(context),
       //body:_listaProdStream(context),
        floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showInput(context);
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
        )
    );
  }

  Widget _listaProdu(BuildContext context){
    return FirebaseAnimatedList(
      //query: prodProvider.prodRef.orderByPriority(),
      query: prodProvider.prodRef.orderByKey(),
      //query: prodProvider.prodRef.orderByChild('createdAt'),
      itemBuilder: (_, snapshot, Animation<double> animation,int x){
        Map dar=snapshot.value;
        final prod2=productFromJson3(json.encode(dar));
       // final prod2= Product.fromJson3(snapshot.value);
        //return _productItem(Product.fromSnapshot(key: snapshot.key, value: snapshot.value));
        //print(dato.cantidad);
        //añadido para dismiss
        final item=snapshot.key;
        //print(item);
        //return card(prod2,item);
        return Dismissible(
          background: Container(color: Colors.red),
          key: UniqueKey(),
          //key: Key(item), 
          onDismissed: (direction){

              prodProvider.delProduct(item);
              //final snackBar = SnackBar(content:Text(prod2.nombre.toString() +" ha sido eliminado"));
              //globalKey.currentState.showSnackBar(snackBar);
          },
          child: card(prod2,context,item)
        );
        //return card(prod2, context);
        
      },
      defaultChild: Center(
         child: CircularProgressIndicator(),
      ),
      reverse: true,

    );
  }
   
  /*
  --//CON STREAMBUILDER TAMB DA, pero no ordenado 
  
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
  
 */
  Widget card(Product producto, BuildContext context, String key){
    
    return Card(
      elevation: 12.0,
      borderOnForeground: true,
      margin: EdgeInsets.all(14.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(124.0),
        child: Container(
          child: ListTile(
              //onTap: () =>_updateInput(context, producto) ,
              leading: Icon(Icons.add_comment) ,
              title: Text(producto.nombre, style: TextStyle(fontSize: 20.0)),
              subtitle: contenido(producto.id, producto.cantidad, producto.precio,producto.createdAt),
              trailing: _inputButton(context,producto,key),
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

  Widget _inputButton(BuildContext context, Product producto, String key){
    return FlatButton(
      onPressed: ()=> _updateInput(context, producto,key), 
      child: Icon(Icons.arrow_drop_down));

  }
  //---Actualizar
  void _updateInput(BuildContext context, Product producto,String key) async{
     await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            //title: Text('Actualiza el producto'),
            content: _inputs2(producto),
            actions: <Widget>[
                _actions2(context,key)
            ],
          );
        }
    );
  }

  _actions2(BuildContext context, String key) {
     return Row(
       children: <Widget>[ 
         FlatButton(
            child: const Text('Cancelar'),
            onPressed: () {
              Navigator.pop(context);
            }
         ),
         FlatButton(
            child: const Text('Actualizar'),
            onPressed: () {
              Product product= new Product(
                id: _idController.text.toString(),
                nombre: _nombreController.text.toString(), 
                cantidad:double.parse(_cantidadController.text), 
                precio: double.parse(_precioController.text)
              );
              prodProvider.updateProducto(key,product);
              Navigator.pop(context);
            }
         )
       ],
     );
  }

  _inputs2(Product producto) {
    _idController.text=producto.id;
    _nombreController.text=producto.nombre;
    _cantidadController.text=producto.cantidad.toString();
    _precioController.text=producto.precio.toString();

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

   Widget _iconInfo(BuildContext context) {
    return FlatButton(
      onPressed: () => _infoText(context), 
      child: Icon(Icons.info, color: Colors.white,)
    );
  }

  _infoText(BuildContext context) async {
    return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Usa la App'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text('1. Click en '),
                  Container(
                    width: 30.0, height: 30.0,
                    child: FloatingActionButton(    
                      onPressed: null, 
                      child: Icon(Icons.add, color: Colors.white,)
                    ),
                  ),
                  Text(' para añadir un'),                  
                ],
              ),
              Text(' nuevo producto.'),
              Text('2. Tap en algún producto para editarlo.'),
              Text('3. Desliza algún producto a la derecha o izquierda para eliminarlo.')
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Ok'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
  }
}