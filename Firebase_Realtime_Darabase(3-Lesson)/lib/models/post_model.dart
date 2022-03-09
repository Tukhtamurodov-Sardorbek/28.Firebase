class Post{
  late String userId;
  late String fullName;
  late String content;
  late String date;

  Post({required this.userId, required this.fullName, required this.content, required this.date});

  Post.fromJson(Map<String, dynamic> json)
      : userId = json['ID'],
        fullName = json['fullName'],
        content = json['content'],
        date = json['date'];

  Map<String, dynamic> toJson() => {
    'ID' : userId,
    'fullName' : fullName,
    'content' : content,
    'date' : date,
  };
}