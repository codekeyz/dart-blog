# Dart Blog 🚀

![dart](https://github.com/codekeyz/yaroo-example/actions/workflows/test.yml/badge.svg) [![Release](https://github.com/codekeyz/dart-blog/actions/workflows/release.yml/badge.svg)](https://github.com/codekeyz/dart-blog/actions/workflows/release.yml) <a title="Made with Fluent Design" href="https://github.com/bdlukaa/fluent_ui"><img src="https://img.shields.io/badge/fluent-design-blue?style=flat-square&color=gray&labelColor=0078D7"></a> [![codecov](https://codecov.io/gh/codekeyz/yaroo-example/graph/badge.svg?token=Q3YPK3LRLR)](https://codecov.io/gh/codekeyz/yaroo-example)

Full-stack Dart project meant to prove that **Dart for Backend** is highly possible in the simplest form if we put in
the work and necessary support. The Backend runs on [Yaroo](https://github.com/codekeyz/yaroo) which serves both the
frontend [Flutter Web](https://flutter.dev/multi-platform/web) and API.

### Setup

Install [`Melos`](https://melos.invertase.dev/~melos-latest) as a global package
via [`pub.dev`](https://pub.dev/packages/melos)

```shell
$ dart pub global activate melos
```

then initialize the workspace using the command below

```shell
$ melos bootstrap
```

### Build

This project consists of a Backend
using [Yaroo](https://github.com/codekeyz/yaroo) & [Flutter Web](https://flutter.dev/multi-platform/web) for the
frontend. You'll need to run this command so Flutter web can be bundled into the `public` folder.

```shell
$ melos build:backend
```

### Migrate Database

Prepare the database **(default: SQLite)** by running the command below. This will create the necessary
tables in the database. You can change the database by editing the `config/database.dart` file.
`MariaB` and `MySQL` are supported for now. `PostgreSQL` coming soon.

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
