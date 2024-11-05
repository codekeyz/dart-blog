import 'package:json_annotation/json_annotation.dart';
import 'package:shared/models.dart';
import 'package:yaroorm/yaroorm.dart';

part 'models.g.dart';

@table
@JsonSerializable(fieldRename: FieldRename.snake)
class ServerUser extends User with Entity<ServerUser> {
  @JsonKey(defaultValue: '', includeToJson: false)
  final String password;

  ServerUser(
    @primaryKey super.id,
    super.name,
    super.email, {
    required this.password,
    @createdAtCol required super.createdAt,
    @updatedAtCol required super.updatedAt,
  }) {
    initialize();
  }

  HasMany<ServerUser, ServerArticle> get articles => hasMany<ServerArticle>(#articles);

  @override
  Map<String, dynamic> toJson() => _$ServerUserToJson(this);

  factory ServerUser.fromJson(Map<String, dynamic> json) => _$ServerUserFromJson(json);
}

@table
@JsonSerializable(fieldRename: FieldRename.snake)
class ServerArticle extends Article with Entity<ServerArticle> {
  ServerArticle(
    @primaryKey super.id,
    super.title,
    @bindTo(ServerUser, onDelete: ForeignKeyAction.cascade) super.ownerId,
    super.description, {
    super.imageUrl,
    @createdAtCol required super.createdAt,
    @updatedAtCol required super.updatedAt,
  }) {
    initialize();
  }

  BelongsTo<ServerArticle, ServerUser> get owner => belongsTo<ServerUser>(#owner);

  @override
  Map<String, dynamic> toJson() => _$ServerArticleToJson(this);

  factory ServerArticle.fromJson(Map<String, dynamic> json) => _$ServerArticleFromJson(json);
}
