import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  //Create a private constructor
  DatabaseHelper._();

  static const databaseName = 'todos_database.db';
  static final DatabaseHelper instance = DatabaseHelper._();
  static Database? _database;

  Future<Database> get database async {
    if (_database == null) {
      return await initializeDatabase();
    }
    return _database!;
  }

  initializeDatabase() async {
    return await openDatabase(join(await getDatabasesPath(), databaseName),
        version: 1, onCreate: (Database db, int version) async {
      await db.execute(
          "CREATE TABLE ${Todo.TABLENAME}(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,title TEXT, authorDescription TEXT, bookDescription TEXT ,bookid INTEGER, authorName TEXT, image TEXT, rating TEXT)");
      await db.execute(
          "CREATE TABLE ${DownloadModel.TABLENAME}(id	INTEGER,image	TEXT ,link	TEXT,title TEXT,PRIMARY KEY(id AUTOINCREMENT))");
    });
  }

  /// Favorite set into table
  insertTodo(Todo todo) async {
    final db = await database;
    var res = await db
        .insert(Todo.TABLENAME, todo.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace)
        .then((value) => print("inserted Favorite $value"));
    return res;
  }

  /// get table
  Future<List<Map<String, dynamic>>> retrieveTodos() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(Todo.TABLENAME);
    return maps;
  }

  Future<bool> likeOrNot(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query(Todo.TABLENAME, where: 'id = ?', whereArgs: [id]);
    return maps.length > 0 ? true : false;
  }

  updateTodo(Todo todo) async {
    final db = await database;
    await db.update(Todo.TABLENAME, todo.toMap(),
        where: 'id = ?',
        whereArgs: [todo.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> deleteTodo({id}) async {
    var db = await database;
    db.delete(Todo.TABLENAME, where: 'id = ?', whereArgs: [id]);
  }

  /// download  ******

  insertDownLoad(DownloadModel todo) async {
    try {
      final db = await database;
      var res = await db
          .insert(DownloadModel.TABLENAME, todo.toMap(),
              conflictAlgorithm: ConflictAlgorithm.replace)
          .then((value) => print("inserted Download $value"));
      return res;
    } catch (e) {
      print('ERROR IN INSERT $e');
    }
  }

  /// get table
  Future<List<Map<String, dynamic>>> retrieveDownLoad() async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query(DownloadModel.TABLENAME);
    return maps;
  }

  Future<bool> retrieveDownloadID({id}) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db
        .query(DownloadModel.TABLENAME, where: 'id = ?', whereArgs: [id]);
    return maps.isEmpty
        ? false
        : maps.length > 0
            ? true
            : false;
  }

  Future<void> deleteDownLoad(int id) async {
    var db = await database;
    db.delete(DownloadModel.TABLENAME, where: 'id = ?', whereArgs: [id]);
  }
}

class Todo {
  final int id;
  final int bookid;
  final String rating;
  final String title;
  final String authorName;
  final String authorDescription;
  final String bookDescription;
  final String image;
  static const String TABLENAME = "favorite";

  Todo(
      {required this.id,
      required this.authorName,
      required this.bookid,
      required this.rating,
      required this.bookDescription,
      required this.authorDescription,
      required this.title,
      required this.image});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'rating': rating,
      'bookid': bookid,
      'authorName': authorName,
      'authorDescription': authorDescription,
      'bookDescription': bookDescription,
      'image': image
    };
  }
}

/// download

class DownloadModel {
  final int id;
  final String image;
  final String title;
  final String link;

  static const String TABLENAME = "download";

  DownloadModel({
    required this.id,
    required this.image,
    required this.link,
    required this.title,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'image': image,
      'link': link,
      'title': title,
    };
  }
}
