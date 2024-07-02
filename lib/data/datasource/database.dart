import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter_apod/model/post.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();

  Database? _database;

  Future<Database> get database async {
    _database ??= await initDB();
    return _database!;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "post_database.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE Posts ("
          "date INTEGER NOT NULL PRIMARY KEY,"
          "copyright TEXT,"
          "explanation TEXT,"
          "hdurl TEXT,"
          "media_type TEXT,"
          "title TEXT,"
          "url TEXT,"
          "videoUrl TEXT,"
          "favorite BIT NOT NULL"
          ")");
    });
  }

  insertPost(Post post) async {
    final db = await database;
    log("insert Posts ${post.toStorageJson()}"); // Develop
    await db.insert(
      "Posts",
      post.toStorageJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  insertsPosts(List<Post> posts) async {
    final db = await database;
    final batch = db.batch();
    posts.forEach((post) {
      log("insert Posts ${post.toStorageJson()}"); // Develop
      batch.insert(
        "Posts",
        post.toStorageJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });
    await batch.commit();
  }

  Future<List<Post>> getPosts(DateTime startDate, DateTime endDate) async {
    final db = await database;
    final List<Map<String, dynamic>> data = await db.query("Posts",
        where: "date BETWEEN ? AND ?",
        whereArgs: [
          startDate.millisecondsSinceEpoch,
          endDate.millisecondsSinceEpoch
        ],
        orderBy: "date desc");
    final posts = data.map((raw) {
      log("get Posts ${Post.fromStorageJson(raw).toString()}"); // Develop
      return Post.fromStorageJson(raw);
    }).toList();
    return posts;
  }

  deletePost(DateTime dateTime) async {
    final db = await database;
    return db.delete("Posts",
        where: "date = ?", whereArgs: [dateTime.millisecondsSinceEpoch]);
  }

  deleteAll() async {
    final db = await database;
    db.rawDelete("Delete * from Posts");
  }
}
