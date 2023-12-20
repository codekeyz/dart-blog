## Yaroo Backend Example 🚀

![dart](https://github.com/codekeyz/yaroo-example/actions/workflows/test.yml/badge.svg) [![codecov](https://codecov.io/gh/codekeyz/yaroo-example/graph/badge.svg?token=Q3YPK3LRLR)](https://codecov.io/gh/codekeyz/yaroo-example)

### Setup

#### Dependencies

```shell
dart pub get && dart run build_runner build --delete-conflicting-outputs
```

#### Migrate Database

```shell
dart run bin/tools/migrator.dart migrate
```

### Start

```shell
dart run
```

### Tests

```shell
dart test
```
