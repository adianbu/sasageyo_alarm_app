import 'dart:async';
import 'dart:io';

import 'package:sasageyo/utils/clientModel.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "AlarmDB.db");
    return await openDatabase(
        // join(await getDatabasesPath(),
        //     "AlarmDB.db"),
        // this is the path that i commented out
        path,
        version: 1,
        onOpen: (db) {}, onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE Client ("
          "id INTEGER PRIMARY KEY,"
          "time TEXT,"
          "vibrate INTEGER,"
          "ringtone TEXT,"
          "label TEXT"
          ")");
    });
  }

  // newClient(Client newClient) async {
  //   final db = await database;
  //   var res = await db.rawInsert(
  //       "INSERT Into Client (id,time,vibrate,ringtone,label)"
  //       " VALUES (${newClient.id},${newClient.time},${newClient.vibrate},${newClient.ringtone},${newClient.label})");
  //   print("Db created");
  //   return res;
  // }

  newClient(Client newClient) async {
    final db = await database;
    var res = await db.insert("Client", newClient.toMap());
    print("Db created");
    return res;
  }

  getClient(int id) async {
    final db = await database;
    var res = await db.query("Client", where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? Client.fromMap(res.first) : Null;
  }

  getAllClients() async {
    final db = await database;
    var res = await db.query("Client");
    List<Client> list =
        res.isNotEmpty ? res.map((c) => Client.fromMap(c)).toList() : [];
    return list;
  }

  Future<List<Client>> getAlarms() async {
    List<Client> _alarms = [];

    var db = await this.database;
    var result = await db.query("Client");
    result.forEach((element) {
      var alarmInfo = Client.fromMap(element);
      _alarms.add(alarmInfo);
    });

    return _alarms;
  }

  deleteClient(int id) async {
    final db = await database;
    db.delete("Client", where: "id = ?", whereArgs: [id]);
  }

  deleteAll() async {
    final db = await database;
    // db.rawDelete("Delete* from Client");
    db.delete("Client");
    print("Deleted");
  }

  Future<dynamic> getClientNew() async {
    final db = await database;
    var res = await db.query("Client");
    if (res.length == 0) {
      return null;
    } else {
      var resMap = res[0];
      return resMap.isNotEmpty ? resMap : Null;
    }
  }
}
