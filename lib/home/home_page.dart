import 'package:flutter/material.dart';
import 'package:flutter_crud/categoria/categoria_page.dart';
import 'package:flutter_crud/db/my_database.dart';
import 'package:flutter_crud/models/produto_categoria.dart';
import 'package:flutter_crud/produto/add_produto_page.dart';
import 'package:get_it/get_it.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
        title: Text('Produtos'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.category),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return CategoriaPage();
                  },
                ));
              })
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) {
                    return AddProdutoPage();
                  },
                  fullscreenDialog: true));
        },
        child: Icon(Icons.add),
      ),
      body: StreamBuilder(
          stream: db.produtoDao.allProdutosWithCategoria(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Center(
                child: CircularProgressIndicator(),
              );

            List<ProdutoWithCategoria> produtos = snapshot.data;

            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return AddProdutoPage(
                          idProduto: produtos[index].produto.id,
                        );
                      }));
                    },
                    leading: CircleAvatar(
                      backgroundColor: Colors.teal,
                      child: Text(produtos[index].produto.id.toString()),
                    ),
                    title: Text(produtos[index].produto.title),
                    subtitle: Text(produtos[index].categoria.name),
                  );
                });
          }),
    );
  }
}
