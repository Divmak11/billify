import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';

class DbHelper{

  static Future<Database> database() async{

    final dbpath= await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbpath,'data.db'),
        onCreate: (database,version) async{
         await  database.execute('CREATE TABLE data(id TEXT PRIMARY KEY,item_name TEXT,item_price TEXT,counter INTEGER)');
         await  database.execute('CREATE TABLE billdata(id TEXT PRIMARY KEY,bill_name TEXT,bill_items TEXT,bill_total TEXT,bill_timestamp TEXT)');
        },version: 1);
  }


  static Future<void> insert(String table,Map<String,Object> data) async{

    final sqlDb = await DbHelper.database();
    sqlDb.insert(
        table,
        data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  static Future<List<Map<String,dynamic>>> getData(String table) async{

    final sqlDb = await DbHelper.database();
    return sqlDb.query(table);
  }

  static Future<void> deleteRecord(String table,String id) async{

    final sqlDb = await DbHelper.database();
    sqlDb.delete(table,where: 'id = ?',whereArgs: [id]);

  }
  static Future<void> updateItemRecord (String table,String id,String name,double price) async{

    final sqlDb = await DbHelper.database();
    sqlDb.update(table, {
      'item_name': name,
      'item_price': price.toString(),
    },
    where: 'id=?',
        whereArgs : [id]
    );
  }
  static Future<void> updateBillRecord (String table,String id,String name,double amount,String dateTime,String items) async{

    final sqlDb = await DbHelper.database();
    sqlDb.update(table, {
      'bill_name': name,
      'bill_total': amount.toString(),
      'bill_timestamp': dateTime,
      'bill_items':  items
    },
        where: 'id=?',
        whereArgs : [id]
    );
  }



}