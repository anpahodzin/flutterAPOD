import 'package:flutter_apod/data/datastore/local/database.dart';
import 'package:flutter_apod/data/datastore/network/network.dart';
import 'package:flutter_apod/di/data_module.dart';
import 'package:http/http.dart' as http;

class MainComponent {
  late final Network _client;
  late final AppDatabase _database;
  late final DataModule dataModule;

  Future<void> init() async {
    _database =
        await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    _client = Network(client: http.Client());
    dataModule = DataModule(_client, _database);
  }
}
