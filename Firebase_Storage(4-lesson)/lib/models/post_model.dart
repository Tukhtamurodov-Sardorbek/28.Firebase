class Post{
  late String userId;
  late String title;
  late String content;
  late String imageURL;
  late String date;

  Post({required this.userId, required this.title, required this.content, required this.imageURL, required this.date});

  Post.fromJson(Map<String, dynamic> json)
      : userId = json['ID'],
        title = json['title'],
        content = json['content'],
        imageURL = json['imageURL'],
        date = json['date'];

  Map<String, dynamic> toJson() => {
    'ID' : userId,
    'title' : title,
    'content' : content,
    'imageURL' : imageURL,
    'date' : date,
  };
}