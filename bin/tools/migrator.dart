import 'package:backend/src/models/article/article.dart';
import 'package:backend/src/models/user/user.dart';
import 'package:yaroo_cli/orm.dart';
import 'package:yaroorm/yaroorm.dart';

import '../../database/config.dart' as orm;

void main(List<String> args) async {
  Query.addTypeDef<User>(userTypeData);
  Query.addTypeDef<Article>(articleTypeData);

  await OrmCLIRunner.start(args, orm.config);
}
