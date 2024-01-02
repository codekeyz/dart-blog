## Yaroo Backend Example 🚀

![dart](https://github.com/codekeyz/yaroo-example/actions/workflows/test.yml/badge.svg) [![codecov](https://codecov.io/gh/codekeyz/yaroo-example/graph/badge.svg?token=Q3YPK3LRLR)](https://codecov.io/gh/codekeyz/yaroo-example)

### Setup

#### Bootstrap Project

```shell
dart pub get && dart run build_runner build --delete-conflicting-outputs
```

#### Run Database Migrations

```shell
dart run bin/tools/migrator.dart migrate
```

> The migrator has 3 main commands for now. `migrate`, `migrate:reset` and `migrate:rollback`. You can run any of these by calling `dart run bin/tools/migrator.dart <command-goes-here>`.

### Start

```shell
dart run
```

### Tests

```shell
dart test
```

Most of the stuffs you'll do in this project, you'll need to re-run the `build_runner` command.

```shell
dart run build_runner build --delete-conflicting-outputs
```
