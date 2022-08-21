import 'package:notes_app/note_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  DatabaseHelper._();
  static DatabaseHelper instance = DatabaseHelper._();
  Database? _database;
  Future<Database> get database async {
    if (_database == null) {
      return createDatabase();
    } else {
      return _database!;
    }
  }

  Future<Database> createDatabase() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'Note.db');
    return await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE Notes (id INTEGER PRIMARY KEY, title TEXT, description TEXT, time TEXT, isArchived INTEGER)');
      _database = db;
    });
  }

  void insertToDatabase(NoteModel model) async {
    var db = await database;
    int n = await db.insert('Notes', model.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    print(n);
  }

  void deleteFromDatabase(NoteModel model) async {
    var db = await database;
    await db.delete(
      'Notes',
      where: 'id=?',
      whereArgs: [model.id],
    );
  }

  void updateDatabase(NoteModel model) async {
    var db = await database;
    await db.update(
      'Notes',
      model.toJson(),
      where: 'id=?',
      whereArgs: [model.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>?> getFromDatabase() async {
    var db = await database;
    List<Map<String, dynamic>>? data = await db.query('Notes');
    print(data);
    return data;
  }
}
