import 'package:flutter/material.dart';
import 'package:flutter_crud/db/my_database.dart';
import 'package:get_it/get_it.dart';

class CategoriaFormPage extends StatefulWidget {
  final int id;

  const CategoriaFormPage({Key key, this.id}) : super(key: key);
  @override
  _CategoriaFormPageState createState() => _CategoriaFormPageState();
}

class _CategoriaFormPageState extends State<CategoriaFormPage> {
  Categoria categoria;
  String categoriaName = '';
  MyDatabase db;
  TextEditingController _nome;

  @override
  void initState() {
    db = GetIt.instance<MyDatabase>();
    _nome = TextEditingController();
    categoria = Categoria(id: null, name: null);

    db.categoriaDao.categoriaById(widget.id).forEach((element) {
      if (element != null) {
        categoria = element;
        _nome.text = categoria.name;
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categoria'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _nome,
              onChanged: (v) {
                categoria = categoria.copyWith(name: v);
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Nome da categoria',
              ),
            ),
            RaisedButton(
              child: Text('Adicionar'),
              onPressed: () {
                if (categoria.id == null) {
                  db.categoriaDao.addCategoria(categoria);
                } else {
                  db.categoriaDao.updateCategoria(categoria);
                }

                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
    );
  }
}
