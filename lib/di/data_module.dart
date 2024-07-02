import 'package:flutter_apod/data/database/database.dart';
import 'package:flutter_apod/data/post/remote/post_network.dart';
import 'package:flutter_apod/data/post/local/post_local_datastore.dart';
import 'package:flutter_apod/data/post/post_repo_data.dart';
import 'package:flutter_apod/data/post/remote/post_remote_datastore.dart';
import 'package:http/http.dart' as http;

class DataModule {
  late final PostDataRepository postRepository;

  DataModule(http.Client client, AppDatabase database) {
    postRepository = PostDataRepository(
        remote: PostRemoteDataStore(PostNetwork(client)),
        local: PostLocalDataStore(dao: database.postDao));
  }
}
