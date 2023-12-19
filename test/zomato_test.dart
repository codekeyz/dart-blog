import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';
import 'package:yaroo/orm/orm.dart';
import 'package:zomato/app/app.dart';
import 'package:zomato/src/models/models.dart';

import '../bin/zomato.reflectable.dart';
import '../config/app.dart' as a1;
import '../config/database.dart' as db;

void main() {
  late final App app = App(a1.config, dbConfig: db.config);

  setUpAll(() async {
    initializeReflectable();

    await app.bootstrap(start_server: false);
  });

  group('Zomato API Tests', () {
    group('when `create user`', () {
      test('should error when invalid params', () async {
        await (await app.tester)
            .post('/api/users', {})
            .expectStatus(422)
            .expectJsonBody({'error': 'Request body cannot be empty'})
            .test();
      });

      test('should create user', () async {
        final newUserData = {'firstname': 'Foo', 'lastname': 'Bar', 'age': 100};

        await (await app.tester)
            .post('/api/users', newUserData)
            .expectJsonBody(
              allOf([
                contains('id'),
                containsPair('firstname', 'Foo'),
                containsPair('lastname', 'Bar'),
                containsPair('age', 100)
              ]),
            )
            .expectStatus(200)
            .expectHeader('content-type', 'application/json; charset=utf-8')
            .test();
      });
    });

    group('when `show user`', () {
      test('should error when invalid params', () async {
        await (await app.tester)
            .get('/api/users/asdf')
            .expectStatus(422)
            .expectJsonBody({'error': "Invalid argument: Invalid parameter value: \"asdf\""}).test();
      });

      test('should return valid user', () async {
        final user = await DB.query('users').get<User>();
        expect(user, isA<User>());

        await (await app.tester).get('/api/users/${user!.id.value}').expectStatus(200).expectJsonBody({
          'id': user.id.value,
          'created_at': user.createdAt.toIso8601String(),
          'updated_at': user.updatedAt.toIso8601String(),
          'firstname': user.firstname,
          'lastname': user.lastname,
          'age': user.age,
        }).test();
      });
    });

    group('when `update user`', () {
      test('should error when invalid params', () async {
        await (await app.tester)
            .put('/api/users/asdf')
            .expectStatus(422)
            .expectJsonBody({'error': "Invalid argument: Invalid parameter value: \"asdf\""}).test();
      });

      test('should error when user not found', () async {
        await (await app.tester).get('/api/users/245').expectStatus(404).expectJsonBody({'error': "Not found"}).test();
      });

      test('should return valid user', () async {
        final user = await DB.query('users').get<User>();
        expect(user, isA<User>());

        await (await app.tester)
            .put('/api/users/${user!.id.value}', body: {'firstname': 'Yango'})
            .expectStatus(200)
            .expectJsonBody({
              'id': user.id.value,
              'created_at': user.createdAt.toIso8601String(),
              'updated_at': user.updatedAt.toIso8601String(),
              'firstname': 'Yango',
              'lastname': user.lastname,
              'age': user.age,
            })
            .test();
      });
    });

    group('when `delete user`', () {
      test('should error when invalid params', () async {
        await (await app.tester)
            .delete('/api/users/asdf')
            .expectStatus(422)
            .expectJsonBody({'error': "Invalid argument: Invalid parameter value: \"asdf\""}).test();
      });

      test('should error when user not found', () async {
        await (await app.tester)
            .delete('/api/users/245')
            .expectStatus(404)
            .expectJsonBody({'error': "Not found"}).test();
      });

      test('should delete user', () async {
        final user = await DB.query('users').get<User>();
        expect(user, isA<User>());

        await (await app.tester)
            .delete('/api/users/${user!.id.value}')
            .expectStatus(200)
            .expectBody('"User ${user.id.value} deleted successfully"')
            .test();
      });
    });
  });

  group('Zomato Web Tests', () {
    test('should show homepage', () async {
      await (await app.tester).get('/').expectStatus(200).expectBody(contains('Welcome to Yaroo 🚀')).test();
    });
  });
}
