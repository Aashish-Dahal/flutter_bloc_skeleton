import '../../core/utils/typedf/index.dart';

List<Posts> _postsFromJson(List data) {
  return List<Posts>.from(data.map((res) => Posts.fromJson(res)));
}

class PostM {
  final List<Posts> data;
  final int count;
  PostM({required this.count, required this.data});
  factory PostM.fromJson(JsonMap json) =>
      PostM(count: json['total'], data: _postsFromJson(json['posts']));

  JsonMap toJson() => {'data': data, 'count': count};
}

class Posts {
  final int id;
  final String title;
  final String body;

  const Posts({required this.id, required this.title, required this.body});

  factory Posts.fromJson(JsonMap json) =>
      Posts(id: json['id'], title: json['title'], body: json['body']);

  JsonMap toJson() => {"id": id, "title": title, "body": body};
}
