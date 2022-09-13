import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SqlDb {
  static Database? _db;
  Future<Database?> get db async {
    if (_db == null) {
      _db = await initDb();
      ("ana hna");
      return _db;
    } else {
      print("anahenak");
      return _db;
    }
  }

  initDb() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, "sqlcoures.db");
    Database mydb = await openDatabase(path,
        onCreate: _onCreate, version: 3, onUpgrade: _onUpgrade);
    return mydb;
  }

  _onUpgrade(Database db, int oldversion, int newversion) async {
    print("on upgrade");
    await db.execute("ALTER TABLE notes ADD COLUMN color TEXT");
  }

  _onCreate(Database db, int version) async {
    await db.execute('''
CREATE TABLE "notes" (
  "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  "note" TEXT NOT NULL
)
    ''');
    print("on create done");
  }

  readData(String sql) async {
    Database? mydb = await db;
    List<Map> respone = await mydb!.rawQuery(sql);
    return respone;
  }

  insertData(String sql) async {
    Database? mydb = await db;
    int respone = await mydb!.rawInsert(sql);
    return respone;
  }

  updateData(String sql) async {
    Database? mydb = await db;
    int respone = await mydb!.rawUpdate(sql);
    return respone;
  }

  deleteData(String sql) async {
    Database? mydb = await db;
    int respone = await mydb!.rawDelete(sql);
    return respone;
  }

  mydeleteDatabase() async {
    String databasepath = await getDatabasesPath();
    String path = join(databasepath, "sqlcoures.db");
    await deleteDatabase(path);
  }
}
