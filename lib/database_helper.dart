import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

import 'user.dart';
import 'models/shoe.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();
  static Database? _database;

  static const String _dbName = 'shoecatalog.db';
  static const String userTable = 'users';
  static const String shoeTable = 'shoes';
  static const int _dbVersion = 1;

  DatabaseHelper._internal();

  Future<Database> get db async {
    _database ??= await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    final dir = await getApplicationDocumentsDirectory();
    final path = join(dir.path, _dbName);
    print('✅ Database initialized at: $path');

    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $userTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL,
        email TEXT NOT NULL
      )
    ''');
    print('✅ Table $userTable created.');

    await db.execute('''
      CREATE TABLE $shoeTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        brand TEXT NOT NULL,
        price TEXT NOT NULL
      )
    ''');
    print('✅ Table $shoeTable created.');
  }

  // Insert user (fixed method signature)
  Future<int> insertUser(User user) async {
    final dbClient = await db;
    final result = await dbClient.insert(userTable, user.toMap());
    print('✅ User inserted.');
    return result;
  }

  // Query all users (fixed typo)
  Future<List<Map<String, dynamic>>> queryAllUsers() async {
    final dbClient = await db;
    return await dbClient.query(userTable);
  }

  // Update user
  Future<int> updateUser(User user) async {
    final dbClient = await db;
    final result = await dbClient.update(
      userTable,
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
    print('✅ User updated.');
    return result;
  }

  // Delete user
  Future<int> deleteUser(int id) async {
    final dbClient = await db;
    final result = await dbClient.delete(
      userTable,
      where: 'id = ?',
      whereArgs: [id],
    );
    print('🗑️ User deleted.');
    return result;
  }

  // Print users to console
  Future<void> printUsersToConsole() async {
    List<Map<String, dynamic>> userMaps = await queryAllUsers();
    List<User> users = userMaps.map((map) => User.fromMap(map)).toList();

    if (users.isEmpty) {
      print('❌ No users found in database.');
    } else {
      for (var user in users) {
        print('👤 ID: ${user.id}, Username: ${user.username}, Email: ${user.email}');
      }
    }
  }

  // Initialize users
  Future<void> initializeUsers() async {
    final dbClient = await db;
    final existingUsers = await dbClient.query(userTable);

    if (existingUsers.isEmpty) {
      List<User> usersToAdd = [
        User(username: 'Palak', email: 'Palak@example.com'),
      ];

      for (User user in usersToAdd) {
        await insertUser(user);
      }
      print('✅ Initial users added.');
    }
  }

  // Insert shoe
  Future<int> insertShoe(Shoe shoe) async {
    final dbClient = await db;
    final result = await dbClient.insert(shoeTable, shoe.toMap());
    print('👟 Shoe inserted.');
    return result;
  }

  // Get all shoes
  Future<List<Shoe>> getShoes() async {
    final dbClient = await db;
    final List<Map<String, dynamic>> maps = await dbClient.query(shoeTable);
    return List.generate(maps.length, (i) => Shoe.fromMap(maps[i]));
  }

  // Update shoe
  Future<int> updateShoe(Shoe shoe) async {
    final dbClient = await db;
    final result = await dbClient.update(
      shoeTable,
      shoe.toMap(),
      where: 'id = ?',
      whereArgs: [shoe.id],
    );
    print('👟 Shoe updated.');
    return result;
  }

  // Delete shoe
  Future<int> deleteShoe(int id) async {
    final dbClient = await db;
    final result = await dbClient.delete(
      shoeTable,
      where: 'id = ?',
      whereArgs: [id],
    );
    print('🗑️ Shoe deleted.');
    return result;
  }
}
