class UserModel {
  late String uid;
  late String userName;
  late String email;
  late String profilePic;
  late String gender;
  String phoneNumber = '';
  late String coverPic;
  String status = 'online';
  String userJob = '';

  UserModel({
    required this.coverPic,
    required this.email,
    required this.profilePic,
    required this.uid,
    required this.userName,
    required this.gender,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    userName = json['userName'];
    email = json['email'];
    profilePic = json['profilePic'];
    gender = json['gender'];
    phoneNumber = json['phoneNumber'];
    coverPic = json['coverPic'];
    status = json['status'];
    userJob = json['userJob'];
  }
  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "userName": userName,
      "email": email,
      "profilePic": profilePic,
      "coverPic": coverPic,
      "status": status,
      "phoneNumber": phoneNumber,
      "gender": gender,
      "userJob": userJob,
    };
  }
}
