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

  @override
  Map<String, dynamic> toJson() => _$UserToJson(this);

  static User fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
