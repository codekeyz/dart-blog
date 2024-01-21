import 'package:backend/app/app.dart';
import 'package:uuid/v4.dart';
import 'package:yaroo/http/http.dart';
import 'package:yaroo/yaroo.dart';

final config = AppConfig.fromJson({
  /*
    |--------------------------------------------------------------------------
    | Application Name
    |--------------------------------------------------------------------------
    |
    */
  'name': env('APP_NAME', defaultValue: 'The Yaroo blog'),

  /*
    |--------------------------------------------------------------------------
    | Application Environment
    |--------------------------------------------------------------------------
    |
    | This value determines the "environment" your application is currently
    | running in. This may determine how you prefer to configure various
    | services the application utilizes. Set this in your ".env" file.
    |
    */

  'env': env<String>('APP_ENV', defaultValue: 'development'),

  /*
    |--------------------------------------------------------------------------
    | Application Debug Mode
    |--------------------------------------------------------------------------
    |
    */

  'debug': env<bool>('APP_DEBUG', defaultValue: true),

  /*
    |--------------------------------------------------------------------------
    | Application URL
    |--------------------------------------------------------------------------
    |
    */

  'url': env<String>('APP_URL', defaultValue: 'http://localhost'),

  /*
    |--------------------------------------------------------------------------
    | Application Port
    |--------------------------------------------------------------------------
    |
    | The port your app will run on. If you don't provide this, the port
    | in URL will be used.
    |
    */

  'port': env<int>('PORT', defaultValue: 80),

  /*
    |--------------------------------------------------------------------------
    | Application Timezone
    |--------------------------------------------------------------------------
    |
    */

  'timezone': 'UTC',

  /*
    |--------------------------------------------------------------------------
    | Application Locale Configuration
    |--------------------------------------------------------------------------
    |
    | The application locale determines the default locale that will be used
    | by the translation service provider. You are free to set this value
    | to any of the locales which will be supported by the application.
    |
    */

  'locale': 'en',

  /*
    |--------------------------------------------------------------------------
    | Encryption Key
    |--------------------------------------------------------------------------
    |
    */

  'key': env('APP_KEY', defaultValue: UuidV4().generate()),

  /*
    |--------------------------------------------------------------------------
    | Autoloaded Service Providers
    |--------------------------------------------------------------------------
    |
    | The service providers listed here will be automatically loaded on the
    | request to your application. Feel free to add your own services to
    | this array to grant expanded functionality to your applications.
    |
    */

  'providers': ServiceProvider.defaultProviders
    ..addAll([
      CoreProvider,
      RouteServiceProvider,
      DatabaseServiceProvider,
      BlogServiceProvider,
    ]),
});
