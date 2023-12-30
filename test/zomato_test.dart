import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';
import 'package:yaroorm/yaroorm.dart';
import 'package:zomato/app/app.dart';

import '../config/app.dart' as app;
import '../config/database.dart' as db;

import 'zomato_test.reflectable.dart';

final zomato = App(app.config);

void main() {
  initializeReflectable();

  DB.init(db.config);

  setUpAll(() => zomato.bootstrap(listen: false));

  group('Zomato API Tests', () {
    group('when `create user`', () {
      test('should error when invalid params', () async {
        await (await zomato.tester)
            .post('/api/users', {})
            .expectStatus(400)
            .expectJsonBody(
              {
                'location': 'body',
                'errors': [
                  'firstname: The field is required',
                  'lastname: The field is required',
                  'age: The field is required'
                ]
              },
            )
            .test();
      });

      test('should create user', () async {
        final newUserData = {'firstname': 'Foo', 'lastname': 'Bar', 'age': 100};

        await (await zomato.tester)
            .post('/api/users', newUserData)
            .expectStatus(200)
            .expectJsonBody(allOf([
              contains('id'),
              containsPair('firstname', 'Foo'),
              containsPair('lastname', 'Bar'),
              containsPair('age', 100)
            ]))
            .test();
      });
    });

    test('should get all users', () async {
      final users = await DB.query<User>().all();

      await (await zomato.tester).get('/api/users').expectStatus(200).expectJsonBody(hasLength(users.length)).test();
    });

    group('when `show user`', () {
      test('should error when invalid params', () async {
        await (await zomato.tester).get('/api/users/asdf').expectStatus(400).expectJsonBody(
          {
            'location': 'param',
            'errors': ['userId must be a int type']
          },
        ).test();
      });

      test('should error when user not found', () async {
        await (await zomato.tester)
            .get('/api/users/245')
            .expectStatus(404)
            .expectJsonBody({'error': "User not found"}).test();
      });

      test('should return valid user', () async {
        final user = await DB.query<User>().get();
        expect(user, isA<User>());

        await (await zomato.tester).get('/api/users/${user!.id.value}').expectStatus(200).expectJsonBody({
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
      test('should error when invalid userId', () async {
        await (await zomato.tester).put('/api/users/asdf').expectStatus(400).expectJsonBody(
          {
            'location': 'param',
            'errors': ['userId must be a int type']
          },
        ).test();
      });

      test('should error when no body', () async {
        final user = await DB.query<User>().get();
        expect(user, isA<User>());

        await (await zomato.tester).put('/api/users/${user!.id.value}').expectStatus(400).expectJsonBody(
          {
            'location': 'body',
            'errors': ['body is required']
          },
        ).test();
      });

      test('should error when user not found', () async {
        await (await zomato.tester)
            .put('/api/users/245', body: {'firstname': 'Hello'})
            .expectStatus(404)
            .expectJsonBody({'error': "User not found"})
            .test();
      });

      test('should return valid user', () async {
        final user = await DB.query<User>().get();
        expect(user, isA<User>());

        await (await zomato.tester)
            .put('/api/users/${user!.id.value}', body: {'firstname': 'Yango'})
            .expectStatus(200)
            .expectJsonBody({
              'id': user.id.value,
              'created_at': user.createdAt.toIso8601String(),
              'updated_at': user.updatedAt.toIso8601String(),
              'firstname': 'Yango',
              'lastname': user.lastname,
              'age': user.age
            })
            .test();
      });
    });

    group('when `delete user`', () {
      test('should error when invalid params', () async {
        await (await zomato.tester).delete('/api/users/asdf').expectStatus(400).expectJsonBody(
          {
            'location': 'param',
            'errors': ['userId must be a int type']
          },
        ).test();
      });

      test('should error when user not found', () async {
        await (await zomato.tester)
            .delete('/api/users/245')
            .expectStatus(404)
            .expectJsonBody({'error': "User not found"}).test();
      });

      test('should delete user', () async {
        final user = await DB.query<User>().get();
        expect(user, isA<User>());

        await (await zomato.tester)
            .delete('/api/users/${user!.id.value}')
            .expectStatus(200)
            .expectBody('"User ${user.id.value} deleted successfully"')
            .test();
      });
    });
  });

  group('Zomato Web Tests', () {
    test('should show homepage', () async {
      await (await zomato.tester).get('/').expectStatus(200).expectBody(contains('Welcome to Yaroo 🚀')).test();
    });

    test('should show 404 page', () async {
      await (await zomato.tester)
          .get('/some-random-page')
          .expectStatus(200)
          .expectBody(allOf(contains('Oops! 😟'), contains('looks like you\'re lost')))
          .test();
    });
  });
}
