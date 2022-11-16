class GoogleUser {
  String? uid;
  String? name;
  String? email;
  String? username;
  String? imageUrl;
  String? status;

  int? state;

  GoogleUser({
    this.uid,
    this.name,
    this.email,
    this.imageUrl,
    this.username,
    this.state,
    this.status,
  });

  Map toMap(GoogleUser user) {
    var data = Map<String, dynamic>();
    data['uid'] = user.uid;
    data['name'] = user.name;
    data['email'] = user.email;
    data['imageUrl'] = user.imageUrl;
    data['username'] = user.username;
    data['state'] = user.state;
    data['status'] = user.status;
    return data;
  }

  GoogleUser.fromMap(Map<String, dynamic> mapData) {
    uid = mapData['uid'];
    name = mapData['name'];
    email = mapData['email'];
    imageUrl = mapData['imageUrl'];
    username = mapData['username'];
    state = mapData['state'];
    status = mapData['status'];
  }
}
