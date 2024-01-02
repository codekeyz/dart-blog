import 'package:path/path.dart' as path;
import 'package:yaroorm/config.dart';

import '../database/migrations/create_users_table.dart';

final config = YaroormConfig.from({
  /*
    |--------------------------------------------------------------------------
    | Default Database Connection Name
    |--------------------------------------------------------------------------
    |
    | Here you may specify which of the database connections below you wish
    | to use as your default connection for all database work. Of course
    | you may use many connections at once using the Database library.
    |
    */

  'default': env('DB_CONNECTION', 'sqlite'),

  /*
    |--------------------------------------------------------------------------
    | Database Connections
    |--------------------------------------------------------------------------
    |
    | Here are each of the database connections setup for your application.
    | Of course, examples of configuring each database platform that is
    | supported by Yaroo is shown below to make development simple.
    |
    |
    | All database work in Yaroo is done through the PHP PDO facilities
    | so make sure you have the driver for your particular database of
    | choice installed on your machine before you begin development.
    |
    */

  'connections': {
    'sqlite': {
      'driver': 'sqlite',
      'database': env('DB_DATABASE', path.absolute('database', 'db.sqlite')),
      'foreign_key_constraints': env('DB_FOREIGN_KEYS', true),
    },
    'mariadb': {
      'driver': 'mariadb',
      'host': env<String>('DB_HOST', ''),
      'port': env<int>('DB_PORT'),
      'database': env<String>('DB_DATABASE', ''),
      'username': env<String>('DB_USERNAME', ''),
      'password': env<String>('DB_PASSWORD', ''),
    }
  },

  /*
    |--------------------------------------------------------------------------
    | Migration Repository Table
    |--------------------------------------------------------------------------
    |
    | This table keeps track of all the migrations that have already run for
    | your application. Using this information, we can determine which of
    | the migrations on disk haven't actually been run in the database.
    |
    */

  'migrations_table': 'migrations',
  'migrations': [CreateUsersTable()]
});
