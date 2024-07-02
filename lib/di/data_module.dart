import 'package:flutter_apod/data/datastore/local/database.dart';
import 'package:flutter_apod/data/datastore/local/post/post_local_datastore.dart';
import 'package:flutter_apod/data/datastore/network/network.dart';
import 'package:flutter_apod/data/datastore/network/post/post_network.dart';
import 'package:flutter_apod/data/datastore/network/post/post_remote_datastore.dart';
import 'package:flutter_apod/data/post_repo_data.dart';

class DataModule {
  late final PostDataRepository postRepository;

  DataModule(Network client, AppDatabase database) {
    postRepository = PostDataRepository(
        remote: PostRemoteDataStore(PostNetwork(client)),
        local: PostLocalDataStore(dao: database.postDao));
  }
}
