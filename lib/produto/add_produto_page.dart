import 'package:flutter/material.dart';
import 'package:flutter_crud/db/my_database.dart';
import 'package:get_it/get_it.dart';

class AddProdutoPage extends StatefulWidget {
  final int idProduto;

  const AddProdutoPage({Key key, this.idProduto}) : super(key: key);

  @override
  _AddProdutoPageState createState() => _AddProdutoPageState();
}

class _AddProdutoPageState extends State<AddProdutoPage> {
  Produto produto = Produto();
  bool _alteracao = false;
  int dropdownValue = null;
  TextEditingController _nome;
  TextEditingController _descricao;
  TextEditingController _qtd;
  TextEditingController _price;

  MyDatabase db;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    db = GetIt.instance<MyDatabase>();
    _nome = TextEditingController();
    _descricao = TextEditingController();
    _qtd = TextEditingController();
    _price = TextEditingController();

    db.produtoDao.getProduto(widget.idProduto).forEach((element) {
      if (element != null) {
        produto = element;

        _nome.text = produto.title;
        _descricao.text = produto.description;
        _qtd.text = produto.qtd.toString();
        _price.text = produto.price.toString();
        dropdownValue = produto.idCategoria;

        _alteracao = true;
      }
    });

    super.initState();
  }

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
                  controller: _nome,
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
                  controller: _descricao,
                  decoration: InputDecoration(
                      hintText: 'Descrição', border: OutlineInputBorder()),
                  onSaved: (v) {
                    produto = produto.copyWith(description: v);
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _qtd,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      hintText: 'Quantidade', border: OutlineInputBorder()),
                  onSaved: (v) {
                    produto = produto.copyWith(qtd: int.tryParse(v));
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _price,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      hintText: 'Preço', border: OutlineInputBorder()),
                  onSaved: (v) {
                    produto = produto.copyWith(price: double.tryParse(v));
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                StreamBuilder<List<Categoria>>(
                    stream: db.categoriaDao.allCategorias,
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
                    print('clicou');
                    print(produto.toJson());
                    if (_alteracao) {
                      await db.produtoDao.updateProduto(produto);
                    } else {
                      await db.produtoDao.addProduto(produto);
                    }

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
