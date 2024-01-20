import 'package:json_annotation/json_annotation.dart';
import 'package:yaroorm/yaroorm.dart';

part 'user.g.dart';

@JsonSerializable()
@EntityMeta(table: 'users', timestamps: true)
class User extends Entity<int, User> {
  final String name;

  final String email;

  @JsonKey(includeToJson: false, defaultValue: '')
  final String password;

  User(this.name, this.email, {required this.password});

  Map<String, dynamic> toJson() => _$UserToJson(this);

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
