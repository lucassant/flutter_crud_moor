import 'package:flutter/material.dart';
import 'package:flutter_crud/categoria/categoria_form_page.dart';
import 'package:flutter_crud/db/my_database.dart';
import 'package:get_it/get_it.dart';

class CategoriaPage extends StatefulWidget {
  @override
  _CategoriaPageState createState() => _CategoriaPageState();
}

class _CategoriaPageState extends State<CategoriaPage> {
  MyDatabase db;

  @override
  void initState() {
    db = GetIt.instance<MyDatabase>();
    super.initState();
  }

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
                          return CategoriaFormPage();
                        },
                        fullscreenDialog: true));
              })
        ],
      ),
      body: StreamBuilder(
          stream: db.categoriaDao.allCategorias,
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
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) {
                                return CategoriaFormPage(
                                    id: categorias[index].id);
                              },
                              fullscreenDialog: true));
                    },
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
