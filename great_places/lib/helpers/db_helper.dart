import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static Future<Database> database() async {
    var dbPath = await getDatabasesPath();
    return await openDatabase(join(dbPath, 'places.db'), version: 2,
        onCreate: (db, version) {
      return db.execute(
        "CREATE TABLE user_places (id TEXT PRIMARY KEY, title TEXT, image TEXT, lat double, lon double);",
      );
    });
  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    var db = await DBHelper.database();
    await db.insert(table, data, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<Map<String, Object>>> get(String table) async {
    var db = await DBHelper.database();
    return db.query(table);
  }
}
