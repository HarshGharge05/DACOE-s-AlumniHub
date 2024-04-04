// class ChatUser{
//   final String id;
// }

class ChatUser {
  ChatUser({
    required this.photoUrl,
    required this.uid,
    // required this.followers,
    // required this.following,
    required this.createdAt,
    required this.about,
    required this.lastActive,
    // required this.isOnline,
    required this.email,
    required this.pushToken,
    required this.username,
  });
  late final String photoUrl;
  late final String uid;
  // late final List<String> followers;
  // late final List<dynamic> following;
  late final String createdAt;
  late final String about;
  late final String lastActive;
  // late final String isOnline;
  late final String email;
  late final String pushToken;
  late final String username;

  ChatUser.fromJson(Map<String, dynamic> json){
    photoUrl = json['photoUrl'] ?? '';
    uid = json['uid'] ?? '';
    // followers = List.castFrom<dynamic, dynam>(json['followers']) ?? '';
    // following = List.castFrom<dynamic, dynamic>(json['following']) ?? '';
    createdAt = json['created_at'] ?? '';
    about = json['about'] ?? '';
    lastActive = json['last_active'] ?? '';
    // isOnline = json['is_online'];
    email = json['email'] ?? '';
    pushToken = json['push_token'] ?? '';
    username = json['username'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['photoUrl'] = photoUrl;
    data['uid'] = uid;
    // data['followers'] = followers;
    // data['following'] = following;
    data['created_at'] = createdAt;
    data['about'] = about;
    data['last_active'] = lastActive;
    // data['is_online'] = isOnline;
    data['email'] = email;
    data['push_token'] = pushToken;
    data['username'] = username;
    return data;
  }
}