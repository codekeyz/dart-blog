import 'package:backend/src/models/article/article.dart';
import 'package:backend/src/models/user/user.dart';
import 'package:yaroorm/yaroorm.dart';

import '../database/config.dart';

void main() async {
  DB.init(config);

  Query.addTypeDef<User>(userTypeData);
  Query.addTypeDef<Article>(articleTypeData);

  final totalUsers = await UserQuery.max('id');
  print(totalUsers);

  // final user = await UserQuery.create(
  //   name: 'Felix Angelo',
  //   email: 'felix@angelo.com',
  //   password: 'hello1234',
  // );

  // print(user.toJson());
}
