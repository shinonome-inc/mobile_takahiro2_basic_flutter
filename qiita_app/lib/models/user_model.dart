class User {
  final String? id;
  final String iconUrl;
  final String? userName;
  final String? description;
  final int? followeesCount;
  final int? followersCount;
  final int? itemsCount;
  User({
    required this.id,
    required this.iconUrl,
    required this.userName,
    required this.description,
    required this.followersCount,
    required this.followeesCount,
    required this.itemsCount
  });
  factory User.fromJson(Map<dynamic, dynamic> json) {
    return User(
        id: (json['id']),
        iconUrl: json['profile_image_url'],
        userName: json['name'],
        description: json['description'],
        followeesCount: json['followees_count'],
        followersCount: json['followers_count'],
        itemsCount: json['items_count']
    );
  }
}