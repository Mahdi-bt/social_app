class ChatModel {
  late String dateTime;
  late String senderId;
  late String reciverId;
  late String messageText;
  String imageUrl = '';
  ChatModel({
    required this.dateTime,
    required this.messageText,
    required this.reciverId,
    required this.senderId,
    required this.imageUrl,
  });

  ChatModel.fromJson(Map<String, dynamic> json) {
    dateTime = json['dateTime'];
    senderId = json['senderId'];
    reciverId = json['reciverId'];
    messageText = json['messageText'];
    imageUrl = json['imageUrl'];
  }
  Map<String, dynamic> toMap() {
    return {
      "dateTime": dateTime,
      "senderId": senderId,
      "reciverId": reciverId,
      "messageText": messageText,
      "imageUrl": imageUrl,
    };
  }
}
