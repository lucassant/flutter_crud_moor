import 'package:flutter_crud/db/my_database.dart';
import 'package:flutter_crud/models/produto_categoria.dart';
import 'package:moor/moor.dart';

part 'produto_dao.g.dart';

@UseDao(tables: [Produtos, Categorias])
class ProdutoDao extends DatabaseAccessor<MyDatabase> with _$ProdutoDaoMixin {
  ProdutoDao(MyDatabase attachedDatabase) : super(attachedDatabase);

  Stream<List<ProdutoWithCategoria>> allProdutosWithCategoria() {
    final query = select(produtos).join(
        [innerJoin(categorias, categorias.id.equalsExp(produtos.idCategoria))]);

    return query.watch().map((rows) {
      return rows.map((row) {
        return ProdutoWithCategoria(
            row.readTable(produtos), row.readTable(categorias));
      }).toList();
    });
  }

  Stream<List<Produto>> get allProdutos => select(produtos).watch();

  Future addProduto(Produto ent) => into(produtos).insert(ent);

  Future updateProduto(Produto ent) => update(produtos).replace(ent);

  Future deleteProduto(Produto ent) => delete(produtos).delete(ent);

  Stream<Produto> getProduto(int id) {
    return (select(produtos)..where((t) => t.id.equals(id))).watchSingle();
  }
}
