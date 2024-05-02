import '../../core/utils/typedf/index.dart';
import '../pagination/index.dart';

List<Posts> _postsFromJson(List data) {
  return List<Posts>.from(data.map((res) => Posts.fromJson(res)));
}

class PostM extends PaginationModel {
  PostM({
    required super.count,
    required super.data,
  });
  factory PostM.fromJson(JsonMap json) => PostM(
        count: json['total'],
        data: _postsFromJson(json['posts']),
      );

  @override
  JsonMap toJson() => {
        'data': data,
        'count': count,
      };
}

class Posts {
  final int id;
  final String title;
  final int reaction;

  const Posts({
    required this.id,
    required this.title,
    required this.reaction,
  });

  factory Posts.fromJson(JsonMap json) => Posts(
        id: json['id'],
        title: json['title'],
        reaction: json['reactions'],
      );

  JsonMap toJson() => {
        "id": id,
        "title": title,
        "reactions": reaction,
      };
}
