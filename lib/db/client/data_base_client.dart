import 'package:sqflite/sqflite.dart';

class DataBaseClient {
  final String tableVaccinationStatus = 'vaccination_status';
  final String columnId = '_id';
  final String name = 'name';
  final String identification = 'identification';
  final String birthDate = 'birthDate';
  final String json = 'json';
  final String isFavorite = 'isFavorite';
  static const dbName = "medcert";
  static DataBaseClient shared = DataBaseClient();
  Database? db;

  DataBaseClient() {
    initDataBase(dbName);
  }

  Future<void> initDataBase(String path) async {
    db = await openDatabase(path, version: 4,
        onCreate: (Database db, int version) async {
      await db.execute('''
        create table $tableVaccinationStatus ( 
          $columnId integer primary key autoincrement, 
          $name text not null,
          $identification text not null,
          $birthDate text not null,
          $json text not null,
          $isFavorite text not null)
        ''');
    }, onUpgrade: (Database db, int oldVersion, int newVersion) async {
      // If you need to add a column
      if (newVersion > oldVersion) {
        db.execute(
            "alter table $tableVaccinationStatus add column $isFavorite text not null default \"\"");
      }
    });
  }

  Future<void> closeDataBase() async {
    if (db != null) {
      db!.close();
    }
  }
}
