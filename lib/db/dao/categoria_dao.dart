import 'package:flutter_crud/db/my_database.dart';
import 'package:moor/moor.dart';

part 'categoria_dao.g.dart';

@UseDao(tables: [Produtos, Categorias])
class CategoriaDao extends DatabaseAccessor<MyDatabase>
    with _$CategoriaDaoMixin {
  CategoriaDao(MyDatabase attachedDatabase) : super(attachedDatabase);

  Stream<List<Categoria>> get allCategorias => select(categorias).watch();

  Stream<Categoria> categoriaById(int id) {
    return (select(categorias)..where((tbl) => tbl.id.equals(id)))
        .watchSingle();
  }

  Future addCategoria(Categoria ent) => into(categorias).insert(ent);

  Future updateCategoria(Categoria ent) => update(categorias).replace(ent);

  Future deleteCategoria(Categoria ent) => delete(categorias).delete(ent);
}
