import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  /// Here, implementing the code for singleton class.
  static final DatabaseHelper _instance = DatabaseHelper._privateConstructor();

  DatabaseHelper._privateConstructor();

  static DatabaseHelper get instance => _instance;

  /// Here, actual code for database related operations.
  ///

  late Database database;

  // Database
  static const String _databaseName = 'nutrition.db';

  /// Tables:
  final String tblFoodRecord = 'food_record';
  final String tblUserProfile = 'user_profile';
  final String tblFavorite = 'favorite';

  /// Table Columns:
  final String colId = 'id';
  final String colData = 'data';
  final String colCreatedAt = 'created_at';

  Future<void> init() async {
    // Open the database and store the reference.
    database = await openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      p.join(await getDatabasesPath(), _databaseName),
      version: 1,
      onCreate: _onCreate,
    );
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    // Query for [tblFoodRecord].
    await db.execute('''
          CREATE TABLE $tblFoodRecord (
            $colId INTEGER PRIMARY KEY,
            $colData TEXT NOT NULL,
            $colCreatedAt TEXT NOT NULL
          )
          ''');
    // Query for [tblUserProfile].
    await db.execute('''
          CREATE TABLE $tblUserProfile (
            $colId INTEGER PRIMARY KEY,
            $colData TEXT NOT NULL
          )
          ''');
    // Query for [tblFavorite].
    await db.execute('''
          CREATE TABLE $tblFavorite (
            $colId INTEGER PRIMARY KEY,
            $colData TEXT NOT NULL,
            $colCreatedAt TEXT NOT NULL
          )
          ''');
  }

  // Helper methods
  Future<void> closeDatabase() async {
    await database.close();
  }

  Future removeDatabase(String databaseName) async {
    await deleteDatabase(p.join(await getDatabasesPath(), databaseName));
  }

  Future<bool> existsDatabase(String databaseName) async {
    return await databaseExists(p.join(await getDatabasesPath(), databaseName));
  }
}
