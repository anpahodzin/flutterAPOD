import 'dart:async';

import 'package:floor/floor.dart';
import 'package:flutter_apod/data/post/local/model/post_entity.dart';
//required for work
import 'package:sqflite/sqflite.dart' as sqflite;

import '../post/local/post_dao.dart';

part 'database.g.dart'; // the generated code will be there

/*
Run the Code Generator
Run the generator with ***"flutter packages pub run build_runner build"***.
To automatically run it, whenever a file changes,
use ***"flutter packages pub run build_runner watch"***.
 */

@Database(version: 1, entities: [PostEntity])
abstract class AppDatabase extends FloorDatabase {
  PostDao get postDao;

  static AppDatabase? _database;

  static Future<AppDatabase> get appDatabase async {
    _database ??= await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    return _database!;
  }
}
