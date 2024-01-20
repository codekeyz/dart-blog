# Dart Blog Backend 🚀

![dart](https://github.com/codekeyz/yaroo-example/actions/workflows/test.yml/badge.svg) </a> [![codecov](https://codecov.io/gh/codekeyz/yaroo-example/graph/badge.svg?token=Q3YPK3LRLR)](https://codecov.io/gh/codekeyz/yaroo-example)

### Setup

Install & Generate Code

```shell
$ dart pub get && dart run build_runner build --delete-conflicting-outputs
```

### Migrate Database

Prepare the database **(default: SQLite)** by running the command below. This will create the necessary
tables in the database. You can change the database by editing the `config/database.dart` file.

Currently supports `MariaB`, `MySQL`, `PostgreSQL` and `SQLite`.

```shell
$ dart run bin/tools/migrator.dart migrate
```

NB: There are only 3 commands for now. `migrate`, `migrate:reset` and `migrate:rollback` and they do
exactly what they are called.

```shell
$ dart run bin/tools/migrator.dart <command-goes-here>
```

### Start Server

```shell
$ dart run
```

### Tests

```shell
$ dart test
```

### Contribution & Workflow

We rely heavily on code-generation. Things like adding a new `Entity`, `Middleware`, `Controller` or `Controller Method`
require you to re-run the command below.

```shell
$ dart pub run build_runner build --delete-conflicting-outputs
```
