import 'package:yaroo/foundation/validation.dart';

class CreateUserDTO extends BaseDTO {
  String get firstname;

  String get lastname;

  int get age;
}

class UpdateUserDTO extends BaseDTO {
  @ezOptional(String)
  String? get firstname;

  @ezOptional(String)
  String? get lastname;

  @ezOptional(int)
  int? get age;

  Map<String, dynamic> get data => {
        if (firstname != null) 'firstname': firstname,
        if (lastname != null) 'lastname': lastname,
        if (age != null) 'age': age,
      };
}
