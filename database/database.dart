// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:backend/src/models/article/article.dart';
import 'package:backend/src/models/user/user.dart';
import 'package:yaroorm/yaroorm.dart';

import './config.dart' as config;
import 'migrations/2024_04_20_003612_create_users_table.dart' as _m0;
import 'migrations/2024_04_20_003614_create_articles_table.dart' as _m1;

void initializeORM() {
  /// Add Type Definitions to Query Runner
  Query.addTypeDef<User>(userTypeData);
  Query.addTypeDef<Article>(articleTypeData);

  /// Configure Migrations Order
  DB.migrations.addAll([
    _m0.CreateUsersTable(),
    _m1.CreateArticlesTable(),
  ]);

  DB.init(config.config);
}
