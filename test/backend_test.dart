import 'dart:convert';
import 'dart:io';

import 'package:backend/backend.dart';
import 'package:backend/src/models/article/article.dart';
import 'package:backend/src/models/user/user.dart';
import 'package:yaroo/yaroo.dart';
import 'package:yaroorm/yaroorm.dart';
import '../database/config.dart' as orm;

import 'backend_test.reflectable.dart';

void main() {
  initializeReflectable();

  DB.init(orm.config);

  late Spookie testAgent;

  setUpAll(() async {
    await blogApp.bootstrap(listen: false);
    testAgent = await blogApp.tester;
  });

  group('Backend API', () {
    const baseAPIPath = '/api';

    group('Auth', () {
      const authPath = '$baseAPIPath/auth';
      group('.register', () {
        final path = '$authPath/register';
        test('should error on invalid body', () async {
          attemptRegister(Map<String, dynamic> body, {dynamic errors}) async {
            return testAgent
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
          final apiResult = await testAgent.post(path, {
            'name': 'Foo User',
            'email': newUserEmail,
            'password': 'foo-bar-mee-moo',
          }).actual;

          expect(apiResult.statusCode, HttpStatus.ok);
          expect(apiResult.headers[HttpHeaders.contentTypeHeader], 'application/json; charset=utf-8');

          final user = User.fromJson(jsonDecode(apiResult.body)['user']);
          expect(user.email, newUserEmail);
          expect(user.name, 'Foo User');
          expect(user.id, isNotNull);
          expect(user.createdAt, isNotNull);
          expect(user.updatedAt, isNotNull);
        });

        test('should error on existing email', () async {
          final randomUser = await UserQuery.findOne();
          expect(randomUser, isA<User>());

          await testAgent
              .post(path, {'email': randomUser!.email, 'name': 'Foo Bar', 'password': 'moooasdfmdf'})
              .expectStatus(HttpStatus.badRequest)
              .expectJsonBody({
                'errors': ['Email already taken']
              })
              .test();
        });
      });

      group('.login', () {
        final path = '$authPath/login';

        test('should error on invalid body', () async {
          attemptLogin(Map<String, dynamic> body, {dynamic errors}) async {
            return testAgent
                .post('$authPath/login', body)
                .expectStatus(HttpStatus.badRequest)
                .expectJsonBody({'location': 'body', 'errors': errors}).test();
          }

          await attemptLogin({}, errors: ['email: The field is required', 'password: The field is required']);
          await attemptLogin({'email': 'foo-bar@hello.com'}, errors: ['password: The field is required']);
          await attemptLogin(
            {'email': 'foo-bar'},
            errors: ['email: The field is not a valid email address', 'password: The field is required'],
          );
        });

        test('should error on in-valid credentials', () async {
          final randomUser = await UserQuery.findOne();
          expect(randomUser, isA<User>());

          final email = randomUser!.email;

          await testAgent
              .post(path, {'email': email, 'password': 'wap wap wap'})
              .expectStatus(HttpStatus.unauthorized)
              .expectJsonBody({
                'errors': ['Email or Password not valid']
              })
              .test();

          await testAgent
              .post(path, {'email': 'holy@bar.com', 'password': 'wap wap wap'})
              .expectStatus(HttpStatus.unauthorized)
              .expectJsonBody({
                'errors': ['Email or Password not valid']
              })
              .test();
        });

        test('should success on valid credentials', () async {
          final randomUser = await UserQuery.findOne();
          expect(randomUser, isA<User>());

          final baseTest = testAgent.post(path, {
            'email': randomUser!.email,
            'password': 'foo-bar-mee-moo',
          });

          await baseTest
              .expectStatus(HttpStatus.ok)
              .expectJsonBody({'user': randomUser.toJson()})
              .expectHeader(HttpHeaders.setCookieHeader, contains('auth=s%'))
              .test();
        });
      });
    });

    group('', () {
      String? authCookie;
      User? currentUser;

      setUpAll(() async {
        currentUser = await UserQuery.findOne();
        expect(currentUser, isA<User>());

        final result = await testAgent.post('$baseAPIPath/auth/login', {
          'email': currentUser!.email,
          'password': 'foo-bar-mee-moo',
        }).actual;

        authCookie = result.headers[HttpHeaders.setCookieHeader];
        expect(authCookie, isNotNull);

        await ArticleQuery.where((article) => article.ownerId(currentUser!.id)).delete();
      });

      group('Users', () {
        final usersApiPath = '$baseAPIPath/users';

        test('should reject if no cookie', () async {
          await testAgent
              .get(usersApiPath)
              .expectStatus(HttpStatus.unauthorized)
              .expectJsonBody({'error': 'Unauthorized'}).test();
        });

        test('should return user for /users/me ', () async {
          await testAgent
              .get('$usersApiPath/me', headers: {HttpHeaders.cookieHeader: authCookie!})
              .expectStatus(HttpStatus.ok)
              .expectHeader(HttpHeaders.contentTypeHeader, 'application/json; charset=utf-8')
              .expectBodyCustom(
                (body) => User.fromJson(jsonDecode(body)['user']),
                isA<User>(),
              )
              .test();
        });

        test('should get user `/users/<userId>` without auth', () async {
          final randomUser = await UserQuery.findOne();
          expect(randomUser, isA<User>());

          await testAgent
              .get('$usersApiPath/${randomUser!.id}')
              .expectStatus(HttpStatus.ok)
              .expectHeader(HttpHeaders.contentTypeHeader, 'application/json; charset=utf-8')
              .expectBodyCustom((body) => jsonDecode(body)['user'], randomUser.toJson())
              .test();
        });
      });

      group('Articles', () {
        final articleApiPath = '$baseAPIPath/articles';

        group('create', () {
          test('should error on invalid body', () async {
            Future<void> attemptCreate(Map<String, dynamic> body, {dynamic errors}) async {
              return testAgent
                  .post(articleApiPath, body, headers: {HttpHeaders.cookieHeader: authCookie!})
                  .expectStatus(HttpStatus.badRequest)
                  .expectJsonBody({'location': 'body', 'errors': errors})
                  .test();
            }

            // when empty body
            await attemptCreate({}, errors: ['title: The field is required', 'description: The field is required']);

            // when short title or description
            await attemptCreate({
              'title': 'a',
              'description': 'df'
            }, errors: [
              'title: The field must be at least 5 characters long',
              'description: The field must be at least 10 characters long'
            ]);
          });

          test('should create with image', () async {
            final result = await testAgent.post(articleApiPath, {
              'title': 'Santa Clause 🚀',
              'description': 'Dart for backend is here',
              'imageUrl': 'https://holy-dart.com/dart-logo-for-shares.png'
            }, headers: {
              HttpHeaders.cookieHeader: authCookie!
            }).actual;
            expect(result.statusCode, HttpStatus.ok);

            final article = Article.fromJson(jsonDecode(result.body)['article']);
            expect(article.ownerId, currentUser!.id);
            expect(article.title, 'Santa Clause 🚀');
            expect(article.description, 'Dart for backend is here');
            expect(article.imageUrl, 'https://holy-dart.com/dart-logo-for-shares.png');
            expect(article.id, isNotNull);
            expect(article.createdAt, isNotNull);
            expect(article.updatedAt, isNotNull);
          });

          test('should use default image if none set', () async {
            final result = await testAgent.post(
              articleApiPath,
              {'title': 'Hurry 🚀', 'description': 'Welcome to the jungle'},
              headers: {HttpHeaders.cookieHeader: authCookie!},
            ).actual;
            expect(result.statusCode, HttpStatus.ok);

            final article = Article.fromJson(jsonDecode(result.body)['article']);
            expect(article.ownerId, currentUser!.id);
            expect(article.title, 'Hurry 🚀');
            expect(article.description, 'Welcome to the jungle');
            expect(article.imageUrl, 'https://dart.dev/assets/shared/dart-logo-for-shares.png');
            expect(article.id, isNotNull);
            expect(article.createdAt, isNotNull);
            expect(article.updatedAt, isNotNull);
          });
        });

        group('update ', () {
          test('should error when invalid params', () async {
            // bad params
            await testAgent
                .put('$articleApiPath/some-random-id', headers: {HttpHeaders.cookieHeader: authCookie!})
                .expectStatus(HttpStatus.badRequest)
                .expectJsonBody({
                  'location': 'param',
                  'errors': ['articleId must be a int type']
                })
                .test();

            // bad body
            await testAgent
                .put('$articleApiPath/234', body: {'name': 'foo'}, headers: {HttpHeaders.cookieHeader: authCookie!})
                .expectStatus(HttpStatus.badRequest)
                .expectJsonBody({
                  'location': 'body',
                  'errors': ['title: The field is required', 'description: The field is required']
                })
                .test();

            // no existing article
            await testAgent
                .put(
                  '$articleApiPath/234',
                  body: {'title': 'Honey', 'description': 'Hold my beer lets talk'},
                  headers: {HttpHeaders.cookieHeader: authCookie!},
                )
                .expectStatus(HttpStatus.notFound)
                .expectJsonBody({'error': 'Not found'})
                .test();
          });

          test('should update article', () async {
            final article = await ArticleQuery.where((article) => article.ownerId(currentUser!.id)).findOne();
            expect(article, isA<Article>());

            expect(article!.title, isNot('Honey'));
            expect(article.description, isNot('Hold my beer lets talk'));

            final result = await testAgent.put(
              '$articleApiPath/${article.id}',
              body: {'title': 'Honey', 'description': 'Hold my beer lets talk'},
              headers: {HttpHeaders.cookieHeader: authCookie!},
            ).actual;
            expect(result.statusCode, HttpStatus.ok);

            final updatedArticle = Article.fromJson(jsonDecode(result.body)['article']);
            expect(updatedArticle.title, 'Honey');
            expect(updatedArticle.description, 'Hold my beer lets talk');
            expect(updatedArticle.toJson(), allOf(contains('id'), contains('createdAt'), contains('updatedAt')));
          });
        });

        group('delete', () {
          test('should error when invalid params', () async {
            // bad params
            await testAgent
                .delete('$articleApiPath/some-random-id', headers: {HttpHeaders.cookieHeader: authCookie!})
                .expectStatus(HttpStatus.badRequest)
                .expectJsonBody({
                  'location': 'param',
                  'errors': ['articleId must be a int type']
                })
                .test();

            const fakeId = 234239389239;
            final article = await ArticleQuery.findById(fakeId);
            expect(article, isNull);

            await testAgent
                .delete('$articleApiPath/$fakeId', headers: {HttpHeaders.cookieHeader: authCookie!})
                .expectStatus(HttpStatus.ok)
                .expectJsonBody({'message': 'Article deleted'})
                .test();
          });

          test('should delete article', () async {
            final article = await ArticleQuery.findByOwnerId(currentUser!.id);
            expect(article, isA<Article>());

            await testAgent
                .delete('$articleApiPath/${article!.id}', headers: {HttpHeaders.cookieHeader: authCookie!})
                .expectStatus(HttpStatus.ok)
                .expectJsonBody({'message': 'Article deleted'})
                .test();

            expect(await ArticleQuery.findById(article.id), isNull);
          });
        });

        group('when get article by Id', () {
          test('should error when invalid articleId', () async {
            await testAgent
                .get('$articleApiPath/some-random-id', headers: {HttpHeaders.cookieHeader: authCookie!})
                .expectStatus(HttpStatus.badRequest)
                .expectJsonBody({
                  'location': 'param',
                  'errors': ['articleId must be a int type']
                })
                .test();
          });

          test('should error when article not exist', () async {
            await testAgent
                .get('$articleApiPath/2348', headers: {HttpHeaders.cookieHeader: authCookie!})
                .expectStatus(HttpStatus.notFound)
                .expectJsonBody({'error': 'Not found'})
                .test();
          });

          test('should show article without auth', () async {
            final article = await ArticleQuery.findByOwnerId(currentUser!.id);
            expect(article, isA<Article>());

            await testAgent
                .get('$articleApiPath/${article!.id}')
                .expectStatus(HttpStatus.ok)
                .expectJsonBody({'article': article.toJson()}).test();
          });
        });

        test('should get Articles without auth', () async {
          final articles = await ArticleQuery.findMany();
          expect(articles, isNotEmpty);

          await testAgent
              .get('$baseAPIPath/articles')
              .expectStatus(HttpStatus.ok)
              .expectHeader(HttpHeaders.contentTypeHeader, 'application/json; charset=utf-8')
              .expectBodyCustom(
            (body) {
              final result = jsonDecode(body)['articles'] as Iterable;
              return result.map((e) => Article.fromJson(e)).toList();
            },
            hasLength(articles.length),
          ).test();
        });
      });
    });
  });
}
