import 'package:floor/floor.dart';

import 'model/post_entity.dart';

@dao
abstract class PostDao {
  @Query("""SELECT * FROM PostEntity WHERE 
  date BETWEEN :startDate AND :endDate 
  ORDER BY date DESC""")
  Future<List<PostEntity>> getPosts(int startDate, int endDate);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertPosts(List<PostEntity> posts);

  @Query("DELETE FROM PostEntity")
  Future<void> clear();
}
