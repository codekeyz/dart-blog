import 'dart:convert';
import 'dart:io';

import 'package:test/test.dart';
import 'package:yaroorm/yaroorm.dart';
import 'package:backend/app/app.dart';

import '../config/app.dart' as app;
import '../config/database.dart' as db;

import 'backend_test.reflectable.dart';

final server = App(app.config);

void main() {
  initializeReflectable();

  DB.init(db.config); // you can use different configs here purposely for testing

  setUpAll(() => server.bootstrap(listen: false));

  group('Zomato API Tests', () {
    const baseAPIPath = '/api';

    group('Auth', () {
      const authPath = '$baseAPIPath/auth';
      group('.register', () {
        final path = '$authPath/register';
        test('should error on invalid body', () async {
          attemptRegister(Map<String, dynamic> body, {dynamic errors}) async {
            return (await server.tester)
                .post(path, body)
                .expectStatus(HttpStatus.badRequest)
                .expectJsonBody({'location': 'body', 'errors': errors}).test();
          }

          // when empty body
          await attemptRegister({}, errors: [
            'name: The field is required',
            'email: The field is required',
            'password: The field is required',
          ]);

          // when only name provide
          await attemptRegister({
            'name': 'Foo'
          }, errors: [
            'email: The field is required',
            'password: The field is required',
          ]);

          // when invalid email
          await attemptRegister({
            'name': 'Foo',
            'email': 'bar'
          }, errors: [
            'email: The field is not a valid email address',
            'password: The field is required',
          ]);

          // when no password
          await attemptRegister(
            {'name': 'Foo', 'email': 'foo@bar.com'},
            errors: ['password: The field is required'],
          );

          // when short password
          await attemptRegister(
            {'name': 'Foo', 'email': 'foo@bar.com', 'password': '344'},
            errors: ['password: The field must be at least 8 characters long'],
          );
        });

        test('should create user', () async {
          final newUserEmail = 'foo-${DateTime.now().millisecondsSinceEpoch}@bar.com';
          final apiResult = await (await server.tester)
              .post(path, {'name': 'Foo User', 'email': newUserEmail, 'password': 'foo-bar-mee-moo'}).actual;

          expect(apiResult.statusCode, HttpStatus.ok);

          // expect json response
          expect(apiResult.headers[HttpHeaders.contentTypeHeader], 'application/json; charset=utf-8');

          // validate api result
          final user = jsonDecode(apiResult.body)['user'];
          expect(user['email'], newUserEmail);
          expect(user['name'], 'Foo User');
          expect(user, allOf(contains('id'), contains('createdAt'), contains('updatedAt')));
        });
      });

      group('.login', () {
        final path = '$authPath/login';

        test('should error on invalid body', () async {
          attemptLogin(Map<String, dynamic> body, {dynamic errors}) async {
            return (await server.tester)
                .post('$authPath/login', body)
                .expectStatus(HttpStatus.badRequest)
                .expectJsonBody({'location': 'body', 'errors': errors}).test();
          }

          // when empty body
          await attemptLogin({}, errors: ['email: The field is required', 'password: The field is required']);

          // when no password
          await attemptLogin({'email': 'foo-bar@hello.com'}, errors: ['password: The field is required']);

          // when invalid email
          await attemptLogin(
            {'email': 'foo-bar'},
            errors: ['email: The field is not a valid email address', 'password: The field is required'],
          );
        });

        test('should error on in-valid credentials', () async {
          final randomUser = await DB.query<User>().get();
          expect(randomUser, isA<User>());

          final email = randomUser!.email;

          await (await server.tester)
              .post(path, {'email': email, 'password': 'wap wap wap'})
              .expectStatus(HttpStatus.unauthorized)
              .expectJsonBody({'error': 'Email or Password not valid'})
              .test();

          await (await server.tester)
              .post(path, {'email': 'holy@bar.com', 'password': 'wap wap wap'})
              .expectStatus(HttpStatus.unauthorized)
              .expectJsonBody({'error': 'Email or Password not valid'})
              .test();
        });

        test('should success on valid credentials', () async {
          final randomUser = await DB.query<User>().get();
          expect(randomUser, isA<User>());

          final email = randomUser!.email;

          final apiResult =
              await (await server.tester).post(path, {'email': email, 'password': 'foo-bar-mee-moo'}).actual;
          expect(apiResult.statusCode, HttpStatus.ok);

          // validate api result
          final user = jsonDecode(apiResult.body)['user'];
          expect(user['id'], randomUser.id!);
          expect(user['email'], email);
          expect(user['name'], randomUser.name);
          expect(randomUser.toPublic, user);
        });
      });
    });
  });
}
