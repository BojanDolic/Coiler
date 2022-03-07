// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coil_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorCoilsDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$CoilsDatabaseBuilder databaseBuilder(String name) =>
      _$CoilsDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$CoilsDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$CoilsDatabaseBuilder(null);
}

class _$CoilsDatabaseBuilder {
  _$CoilsDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$CoilsDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$CoilsDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<CoilsDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$CoilsDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$CoilsDatabase extends CoilsDatabase {
  _$CoilsDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  CoilDao? _coilDaoInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback? callback]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 7,
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
            'CREATE TABLE IF NOT EXISTS `Coil` (`id` INTEGER, `coilName` TEXT NOT NULL, `coilDesc` TEXT NOT NULL, `coilType` TEXT NOT NULL, `resonantFrequency` REAL NOT NULL, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  CoilDao get coilDao {
    return _coilDaoInstance ??= _$CoilDao(database, changeListener);
  }
}

class _$CoilDao extends CoilDao {
  _$CoilDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _coilInsertionAdapter = InsertionAdapter(
            database,
            'Coil',
            (Coil item) => <String, Object?>{
                  'id': item.id,
                  'coilName': item.coilName,
                  'coilDesc': item.coilDesc,
                  'coilType': item.coilType,
                  'resonantFrequency': item.resonantFrequency
                },
            changeListener),
        _coilDeletionAdapter = DeletionAdapter(
            database,
            'Coil',
            ['id'],
            (Coil item) => <String, Object?>{
                  'id': item.id,
                  'coilName': item.coilName,
                  'coilDesc': item.coilDesc,
                  'coilType': item.coilType,
                  'resonantFrequency': item.resonantFrequency
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Coil> _coilInsertionAdapter;

  final DeletionAdapter<Coil> _coilDeletionAdapter;

  @override
  Stream<List<Coil>> getCoils() {
    return _queryAdapter.queryListStream('SELECT * FROM Coil',
        mapper: (Map<String, Object?> row) => Coil(
            row['id'] as int?,
            row['coilName'] as String,
            row['coilDesc'] as String,
            row['coilType'] as String,
            row['resonantFrequency'] as double),
        queryableName: 'Coil',
        isView: false);
  }

  @override
  Future<void> insertCoil(Coil coil) async {
    await _coilInsertionAdapter.insert(coil, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteCoil(Coil coil) async {
    await _coilDeletionAdapter.delete(coil);
  }
}
