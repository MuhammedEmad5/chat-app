class MessageDataModel {
  String? text;
  String? dateTime;
  String? senderPhone;
  String? receiverPhone;
  String? photo;


  MessageDataModel({
    this.text,
    this.senderPhone,
    this.dateTime,
    this.receiverPhone,
    this.photo
  });

  MessageDataModel.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    dateTime = json['dateTime'];
    senderPhone = json['senderPhone'];
    receiverPhone = json['receiverPhone'];
    photo = json['photo'];
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'dateTime': dateTime,
      'senderPhone': senderPhone,
      'receiverPhone': receiverPhone,
      'photo': photo,

    };
  }
}
