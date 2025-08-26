import 'dart:io';

import 'package:gorcery_app/Services/grocerymodal.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class Dbhelper {
  Dbhelper._();
  static Dbhelper instance = Dbhelper._();

  Database? db;

  static String TableName = "GroceryTable";
  static String idColumn = "id";
  static String groceryColumn = "GroceryColumn";

  Future<Database> getDB() async {
    return db ?? await initDB();
  }

  Future<Database> initDB() async {
    Directory db = await getApplicationDocumentsDirectory();
    final path = join(db.path, 'Grocery.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
           CREATE TABLE $TableName(
           $idColumn INTEGER PRIMARY KEY AUTOINCREMENT,
           $groceryColumn TEXT)
        ''');
      },
    );
  }

  //insert grocery
  Future<int> InsertGrocery(GroceryModal modal) async {
    final db = await getDB();
    return db.insert(TableName, modal.toJson());
  }

  //delete grocery
  Future<int> DeleteGrocery(GroceryModal modal) async {
    final db = await getDB();
    return db.delete(TableName, where: 'id = ?', whereArgs: [modal.id]);
  }

  //update grocery
  Future<int> UpdateGrocery(GroceryModal modal) async {
    final db = await getDB();
    return db.update(
      TableName,
      modal.toJson(),
      where: 'id = ?',
      whereArgs: [modal.id],
    );
  }

  //return list of groceries
  Future<List<GroceryModal>> GetGroceries() async {
    final db = await getDB();
    List<Map<String, dynamic>> data = await db.query(TableName);

    return data.map((c) => GroceryModal.fromJson(c)).toList();
  }
}
