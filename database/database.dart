// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:backend/src/models.dart';
import 'package:backend/src/utils/config.dart' as config;
import 'package:yaroorm/yaroorm.dart';

import 'migrations/2024_04_20_003612_initial_setup.dart' as _m0;

void initializeORM() {
  /// Add Type Definitions to Query Runner
  Query.addTypeDef<ServerUser>(serveruserTypeDef);
  Query.addTypeDef<ServerArticle>(serverarticleTypeDef);

  /// Configure Migrations Order
  DB.migrations.addAll([
    _m0.InitialTableSetup(),
  ]);

  DB.init(config.config);
}
