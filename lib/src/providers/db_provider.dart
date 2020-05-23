import "dart:io";

import "package:path_provider/path_provider.dart";
import "package:qr_app/src/models/scan_model.dart";
import "package:sqflite/sqflite.dart";
import "package:path/path.dart";

class DBProvider {
  static Database _database;
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, "ScansDB.db");
    return await openDatabase(
      path,
      version: 1,
      onOpen: (db) {},
      onCreate: (db, version) async {
        await db.execute("CREATE TABLE Scans("
            " id INTEGER PRIMARY KEY,"
            " tipo TEXT,"
            " valor TEXT,"
            ")");
      },
    );
  }

  newScanRaw(ScanModel newScan) async {
    final db = await database;
    final res = await db.rawInsert("INSERT INTO Scans (id, tipo, valor) "
        "VALUES (${newScan.id}, '${newScan.tipo}', '${newScan.valor}')");
    return res;
  }

  nuevoScan(ScanModel nuevoScan) async {
    final db = await database;
    return await db.insert("Scans", nuevoScan.toJson());
  }

  Future<ScanModel> getScanById(int id) async {
    final db = await database;
    final res = await db.query('Scans', where: 'id=?', whereArgs: [id]);
    return res.isNotEmpty ? ScanModel.fromJson(res.first) : null;
  }

  Future<List<ScanModel>> getAllScans() async {
    final db = await database;
    final res = await db.query('Scans');
    return res.isNotEmpty ? res.map((e) => ScanModel.fromJson(e)).toList() : [];
  }

  Future<List<ScanModel>> getScansByType(String type) async {
    final db = await database;
    final res = await db.rawQuery("SELECT * FROM Scans WHERE tipo='$type'");
    return res.isNotEmpty ? res.map((e) => ScanModel.fromJson(e)).toList() : [];
  }

  updateScan(ScanModel scan) async {
    final db = await database;
    return await db.update('Scans', scan.toJson(), where: 'id=?', whereArgs: [scan.id]);
  }
}
