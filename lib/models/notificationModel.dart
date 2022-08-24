class NotificationModel {
  late String senderUid;
  late String reciverUid;
  late String type;
  late String date;
  late String postUid;
  late String userName;
  NotificationModel({
    required this.date,
    required this.reciverUid,
    required this.senderUid,
    required this.type,
    required this.postUid,
    required this.userName,
  });

  NotificationModel.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    reciverUid = json['reciverUid'];
    senderUid = json['senderUid'];
    type = json['type'];
    postUid = json['postUid'];
    userName = json['userName'];
  }

  Map<String, dynamic> toMap() {
    return {
      "date": date,
      "reciverUid": reciverUid,
      "senderUid": senderUid,
      "type": type,
      "postUid": postUid,
      "userName": userName,
    };
  }
}
