class CommentModel {
  late String commentText;
  late String commentUserUid;
  late String date;
  late String commentUserPic;

  CommentModel(
      {required this.commentText,
      required this.commentUserPic,
      required this.commentUserUid,
      required this.date});

  CommentModel.formJson(Map<String, dynamic> json) {
    commentText = json['commentText'];
    commentUserUid = json['commentUserUid'];
    date = json['date'];
    commentUserPic = json['commentUserPic'];
  }

  Map<String, dynamic> toMap() {
    return {
      "commentText": commentText,
      "commentUserUid": commentUserUid,
      "date": date,
      "commentUserPic": commentUserPic,
    };
  }
}
