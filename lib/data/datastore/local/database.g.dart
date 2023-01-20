// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  PostDao? _postDaoInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback? callback]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `PostEntity` (`copyright` TEXT, `date` INTEGER NOT NULL, `explanation` TEXT NOT NULL, `hdurl` TEXT NOT NULL, `mediaType` TEXT NOT NULL, `title` TEXT NOT NULL, `url` TEXT NOT NULL, `videoUrl` TEXT, `favorite` INTEGER NOT NULL, PRIMARY KEY (`date`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  PostDao get postDao {
    return _postDaoInstance ??= _$PostDao(database, changeListener);
  }
}

class _$PostDao extends PostDao {
  _$PostDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _postEntityInsertionAdapter = InsertionAdapter(
            database,
            'PostEntity',
            (PostEntity item) => <String, Object?>{
                  'copyright': item.copyright,
                  'date': item.date,
                  'explanation': item.explanation,
                  'hdurl': item.hdurl,
                  'mediaType': item.mediaType,
                  'title': item.title,
                  'url': item.url,
                  'videoUrl': item.videoUrl,
                  'favorite': item.favorite ? 1 : 0
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<PostEntity> _postEntityInsertionAdapter;

  @override
  Future<List<PostEntity>> getPosts(int startDate, int endDate) async {
    return _queryAdapter.queryList(
        'SELECT * FROM PostEntity WHERE    date BETWEEN ?1 AND ?2    ORDER BY date DESC',
        mapper: (Map<String, Object?> row) => PostEntity(copyright: row['copyright'] as String?, date: row['date'] as int, explanation: row['explanation'] as String, hdurl: row['hdurl'] as String, mediaType: row['mediaType'] as String, title: row['title'] as String, url: row['url'] as String, videoUrl: row['videoUrl'] as String?, favorite: (row['favorite'] as int) != 0),
        arguments: [startDate, endDate]);
  }

  @override
  Future<void> clear() async {
    await _queryAdapter.queryNoReturn('DELETE FROM PostEntity');
  }

  @override
  Future<void> insertPosts(List<PostEntity> posts) async {
    await _postEntityInsertionAdapter.insertList(
        posts, OnConflictStrategy.replace);
  }
}
