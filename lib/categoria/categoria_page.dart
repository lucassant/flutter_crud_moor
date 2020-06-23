import 'package:flutter/material.dart';
import 'package:flutter_crud/db/my_database.dart';

class CategoriaPage extends StatefulWidget {
  @override
  _CategoriaPageState createState() => _CategoriaPageState();
}

class _CategoriaPageState extends State<CategoriaPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categorias'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) {
                          return AddCategoria();
                        },
                        fullscreenDialog: true));
              })
        ],
      ),
      body: StreamBuilder(
          stream: MyDatabase.instance.categoriaDao.allCategorias,
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Center(
                child: CircularProgressIndicator(),
              );

            List<Categoria> categorias = snapshot.data;

            return ListView.builder(
                itemCount: categorias.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      child: Text(categorias[index].id.toString()),
                    ),
                    title: Text(categorias[index].name),
                  );
                });
          }),
    );
  }
}

class AddCategoria extends StatefulWidget {
  @override
  _AddCategoriaState createState() => _AddCategoriaState();
}

class _AddCategoriaState extends State<AddCategoria> {
  String categoriaName = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adicionar categoria'),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          TextField(
            onChanged: (v) {
              categoriaName = v;
            },
          ),
          RaisedButton(
            child: Text('Adicionar'),
            onPressed: () {
              /*MyDatabase.instance.categoriaDao.addCategoria(
                  CategoriasCompanion(name: Value(categoriaName)));*/
              MyDatabase.instance.categoriaDao
                  .addCategoria(Categoria(name: categoriaName));
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }
}
