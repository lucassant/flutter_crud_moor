import 'package:flutter/material.dart';
import 'package:flutter_crud/db/my_database.dart';

class AddProdutoPage extends StatefulWidget {
  @override
  _AddProdutoPageState createState() => _AddProdutoPageState();
}

class _AddProdutoPageState extends State<AddProdutoPage> {
  Produto produto = Produto();
  int dropdownValue = null;
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Adicionar produto')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
            key: formKey,
            child: ListView(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                      hintText: 'Nome', border: OutlineInputBorder()),
                  onSaved: (v) {
                    produto = produto.copyWith(title: v);
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  decoration: InputDecoration(
                      hintText: 'Descrição', border: OutlineInputBorder()),
                  onSaved: (v) {
                    produto = produto.copyWith(description: v);
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                StreamBuilder<List<Categoria>>(
                    stream: MyDatabase.instance.categoriaDao.allCategorias,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return Container();

                      List<Categoria> lista = snapshot.data;
                      return DropdownButtonFormField(
                        hint: Text('Selecione a categoria'),
                        value: dropdownValue,
                        items: lista
                            .map((e) => DropdownMenuItem(
                                  child: Text(e.name),
                                  value: e.id,
                                ))
                            .toList(),
                        onSaved: (v) {
                          produto = produto.copyWith(idCategoria: v);
                        },
                        onChanged: (int value) {
                          setState(() {
                            dropdownValue = value;
                          });
                          print('valor $value');
                        },
                      );
                    }),
                SizedBox(
                  height: 20,
                ),
                RaisedButton(
                  onPressed: () async {
                    formKey.currentState.save();

                    produto = produto.copyWith(qtd: 1, price: 10.0);

                    print(produto.toJson());
                    await MyDatabase.instance.produtoDao.addProduto(produto);
                    Navigator.pop(context);
                  },
                  child: Text('Salvar produto'),
                ),
              ],
            )),
      ),
    );
  }
}
