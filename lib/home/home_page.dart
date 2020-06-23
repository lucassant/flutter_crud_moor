import 'package:flutter/material.dart';
import 'package:flutter_crud/categoria/categoria_page.dart';
import 'package:flutter_crud/db/my_database.dart';
import 'package:flutter_crud/models/produto_categoria.dart';
import 'package:flutter_crud/produto/add_produto_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Produtos'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.add),
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
          stream: MyDatabase.instance.produtoDao.allProdutosWithCategoria(),
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
                    leading: CircleAvatar(
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
