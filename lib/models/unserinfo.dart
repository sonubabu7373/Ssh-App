class UserInfo {
  int? id;
  String? uname;
  String? hostname;

  UserInfo({this.id, this.uname, this.hostname});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{"id": id, "uname": uname, "hostname": hostname};
  }
}
