import 'package:pharaoh/pharaoh_next.dart';

class CreateArticleDTO extends BaseDTO {
  @ezMinLength(5)
  String get title;

  @ezMinLength(10)
  String get description;

  @ezOptional(String)
  String? get imageUrl;
}
