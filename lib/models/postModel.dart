class PostModel {
  late String postTitle;
  late String mediaUrl;
  late String postTime;
  late String posterUid;
  late String posterPhotoUrl;
  late String posterName;
  String pdfUrl = "";
  int postComment = 0;
  int postLikes = 0;

  PostModel({
    required this.mediaUrl,
    this.postComment = 0,
    this.postLikes = 0,
    this.pdfUrl = "",
    required this.postTime,
    required this.postTitle,
    required this.posterName,
    required this.posterUid,
    required this.posterPhotoUrl,
  });

  PostModel.fromJson(Map<String, dynamic> json) {
    postTitle = json['postTitle'];
    mediaUrl = json['mediaUrl'];
    postTime = json['postTime'];
    posterUid = json['posterUid'];
    posterPhotoUrl = json['posterPhotoUrl'];
    posterName = json['posterName'];
    postComment = json['postComment'];
    postLikes = json['postLikes'];
    pdfUrl = json['pdfUrl'];
  }

  Map<String, dynamic> toMap() {
    return {
      "postTitle": postTitle,
      "mediaUrl": mediaUrl,
      "postTime": postTime,
      "posterUid": posterUid,
      "posterPhotoUrl": posterPhotoUrl,
      "posterName": posterName,
      "postComment": postComment,
      "postLikes": postLikes,
      "pdfUrl": pdfUrl,
    };
  }
}
