import 'package:flutter_crud/db/dao/categoria_dao.dart';
import 'package:flutter_crud/db/dao/produto_dao.dart';
import 'package:moor/moor.dart';
import 'package:moor_flutter/moor_flutter.dart';
part 'my_database.g.dart';

class Produtos extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get description => text()();
  IntColumn get qtd => integer()();
  RealColumn get price => real()();
  IntColumn get idCategoria => integer()();
}

class Categorias extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
}

@UseMoor(tables: [Produtos, Categorias], daos: [ProdutoDao, CategoriaDao])
class MyDatabase extends _$MyDatabase {
  static MyDatabase instance = MyDatabase._internal();

  ProdutoDao produtoDao;
  CategoriaDao categoriaDao;

  MyDatabase._internal()
      : super(FlutterQueryExecutor.inDatabaseFolder(
            path: 'db.sqlite', logStatements: true)) {
    produtoDao = ProdutoDao(this);
    categoriaDao = CategoriaDao(this);
  }

  @override
  int get schemaVersion => 1;
}
