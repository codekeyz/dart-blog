# Dart Blog 🚀

![dart](https://github.com/codekeyz/yaroo-example/actions/workflows/test.yml/badge.svg) [![Release](https://github.com/codekeyz/dart-blog/actions/workflows/release.yml/badge.svg)](https://github.com/codekeyz/dart-blog/actions/workflows/release.yml) <a title="Made with Fluent Design" href="https://github.com/bdlukaa/fluent_ui"><img src="https://img.shields.io/badge/fluent-design-blue?style=flat-square&color=gray&labelColor=0078D7"></a> [![codecov](https://codecov.io/gh/codekeyz/yaroo-example/graph/badge.svg?token=Q3YPK3LRLR)](https://codecov.io/gh/codekeyz/yaroo-example)

### Setup

To setup and run this project, Install [`Melos`](https://melos.invertase.dev/~melos-latest) as a global package via [`pub.dev`](https://pub.dev/packages/melos);

```shell
$ dart pub global activate melos
```

then initialize the workspace using the command below

```shell
$ melos bootstrap
```

### Generate code

This project consists of a Backend using Yaroo & Flutter Web for the frontend. You'll need to run this command so Flutter web can be bundled into the `public` folder.

```shell
$ melos build:backend
```

Also this project relies heavily on `build_runner` for code-generation. Most of the components require you to re-run this command. Things like adding a new `Middleware`, `Controller`, `Controller Method` require
you to re-run this command. If something's not working, just re-run this.

```shell
$ dart pub run build_runner build --delete-conflicting-outputs
```

<<<<<<< HEAD
### Database Migration
=======
#### Database Migration
>>>>>>> f46657d (add release badge)

This project comes with a CLI for running migrations on your database. There are only 3 main commands for now. `migrate`, `migrate:reset` and `migrate:rollback`.

```shell
$ dart run bin/tools/migrator.dart <command-goes-here>
```

The project uses `sqlite` by default. You can configure it to use `MariaDB` or `MySQL`.

<<<<<<< HEAD
### Start Server
=======
#### Start Server
>>>>>>> f46657d (add release badge)

```shell
$ dart run
```

### Tests

```shell
$ dart test
```
